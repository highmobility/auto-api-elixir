# AutoAPI
# Copyright (C) 2018 High-Mobility GmbH
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see http://www.gnu.org/licenses/.
#
# Please inquire about commercial licensing options at
# licensing@high-mobility.com
defmodule AutoApi.DoorLocksCommand do
  @moduledoc """
  Handles Door Locks commands and apply binary commands on %AutoApi.DoorLocksCommand{}
  """
  @behaviour AutoApi.Command

  alias AutoApi.DoorLocksState
  alias AutoApi.DoorLocksCapability
  @doc """
  Parses the binary command and makes changes or returns the state

      iex> AutoApi.DoorLocksCommand.execute(%AutoApi.DoorLocksState{}, <<0x00>>)
      {:state, %AutoApi.DoorLocksState{}}

      iex> AutoApi.DoorLocksCommand.execute(%AutoApi.DoorLocksState{}, <<1, 4, 0, 0, 0, 1, 0, 0, 2, 1, 0, 3, 0, 1>>)
      {:state_changed, %AutoApi.DoorLocksState{doors: [
        %AutoApi.DoorLockState{location: :front_left, lock: :unlocked, position: :closed},
        %AutoApi.DoorLockState{location: :front_right, lock: :unlocked, position: :closed},
        %AutoApi.DoorLockState{location: :rear_right, lock: :unlocked, position: :open},
        %AutoApi.DoorLockState{location: :rear_left, lock: :locked, position: :closed},
      ]}}

      iex> AutoApi.DoorLocksCommand.execute(%AutoApi.DoorLocksState{doors: [%AutoApi.DoorLockState{location: :front_left, lock: :locked}]}, <<0x02, 0x00>>)
      {:state_changed, %AutoApi.DoorLocksState{doors: [
        %AutoApi.DoorLockState{location: :front_left, lock: :unlocked},
      ]}}

      iex> AutoApi.DoorLocksCommand.execute(%AutoApi.DoorLocksState{doors: [%AutoApi.DoorLockState{location: :front_left, lock: :unlocked}]}, <<0x02, 0x01>>)
      {:state_changed, %AutoApi.DoorLocksState{doors: [
        %AutoApi.DoorLockState{location: :front_left, lock: :locked},
      ]}}

  """
  @spec execute(%AutoApi.DoorLocksState{}, binary) :: {AutoApi.Command.execute_return_atom, %AutoApi.DoorLocksState{}}
  def execute(%DoorLocksState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%DoorLocksState{} = state, <<0x1, _num_doors, doors::binary>>) do
    new_state = DoorLocksState.from_bin(doors)
    if state == new_state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  def execute(%DoorLocksState{} = state, <<0x02, cmd>>) do
    new_state = DoorLocksState.change_locks_status(state, cmd)
    if state == new_state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts DoorLocks state to capability's state in binary

      iex> AutoApi.DoorLocksCommand.state(%AutoApi.DoorLocksState{doors: [%AutoApi.DoorLockState{location: :front_left, lock: :locked, position: :open}]})
      <<0x01, 0x01, 0x00, 0x01, 0x01>>
  """
  def state(%DoorLocksState{} = state) do
    resp = AutoApi.DoorLocksState.to_bin(state)
    <<0x01>> <> resp
  end

  @doc """
  Converts DoorLocks state to capability's vehicle state binary

      iex> AutoApi.DoorLocksCommand.vehicle_state(%AutoApi.DoorLocksState{})
      <<0x01, 0x00>>

      iex> AutoApi.DoorLocksCommand.vehicle_state(%AutoApi.DoorLocksState{doors: [%AutoApi.DoorLockState{location: :rear_left, lock: :locked, position: :closed}]})
      <<0x04, 0x01, 0x03, 0x00, 0x01>>
  """
  def vehicle_state(%DoorLocksState{} = state) do
    resp = AutoApi.DoorLocksState.to_bin(state)
    resp_size = byte_size(resp)
    <<resp_size>> <> resp
  end

  @doc """
  Returns binary command
      iex> AutoApi.DoorLocksCommand.to_bin(:get_lock_state, [])
      <<0x00>>
      iex> AutoApi.DoorLocksCommand.to_bin(:lock_unlock_doors, [:unlock])
      <<0x02, 0x00>>
      iex> AutoApi.DoorLocksCommand.to_bin(:lock_unlock_doors, [:lock])
      <<0x02, 0x01>>
  """
  @spec to_bin(DoorLocksCapability.command_type, list(any)) :: binary
  def to_bin(:get_lock_state, _args) do
    cmd_id = DoorLocksCapability.command_id(:get_lock_state)
    <<cmd_id>>
  end
  def to_bin(:lock_unlock_doors, [new_lock_state]) when new_lock_state in [:lock, :unlock] do
    cmd_id = DoorLocksCapability.command_id(:lock_unlock_doors)
    lock_bin = if new_lock_state == :unlock, do: 0x00, else: 0x01
    <<cmd_id, lock_bin>>
  end
end
