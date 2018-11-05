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
  Handles  commands and apply binary commands on `%AutoApi.DoorLocksState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.DoorLocksState
  alias AutoApi.DoorLocksCapability

  @doc """
  Parses the binary command and makes changes or returns the state

        iex> AutoApi.DoorLocksCommand.execute(%AutoApi.DoorLocksState{}, <<0x00>>)
        {:state, %AutoApi.DoorLocksState{}}

        iex> command = <<0x01>> <> <<0x03, 2::integer-16, 0x01, 0x01>> <> <<0x03, 2::integer-16, 0x00, 0x00>>
        iex> AutoApi.DoorLocksCommand.execute(%AutoApi.DoorLocksState{}, command)
        {:state_changed, %AutoApi.DoorLocksState{locks: [%{door_location: :front_left, lock_state: :unlocked}, %{door_location: :front_right, lock_state: :locked}]}}

  """
  @spec execute(DoorLocksState.t(), binary) :: {:state | :state_changed, DoorLocksState.t()}
  def execute(%DoorLocksState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%DoorLocksState{} = state, <<0x01, ds::binary>>) do
    new_state = DoorLocksState.from_bin(ds)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  def execute(%DoorLocksState{} = state, <<0x12, 0x01, lock_command>>) do
    lock_state = if lock_command == 0x00, do: :unlocked, else: :locked

    locks = Enum.map(state.locks, fn door -> %{door | lock_state: lock_state} end)

    new_state = %{state | locks: locks}

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts DoorLocksCommand state to capability's state in binary

        iex> AutoApi.DoorLocksCommand.state(%AutoApi.DoorLocksState{positions: [%{door_location: :front_left, position: :closed}], properties: [:positions]})
        <<1, 4, 0, 2, 0, 0>>
  """
  @spec state(DoorLocksState.t()) :: binary
  def state(%DoorLocksState{} = state) do
    <<0x01, DoorLocksState.to_bin(state)::binary>>
  end

  @doc """
  Returns binary command
      iex> AutoApi.DoorLocksCommand.to_bin(:get_lock_state, [])
      <<0x00>>

      iex> AutoApi.DoorLocksCommand.to_bin(:lock_unlock_doors, [lock_state: :unlock])
      <<0x12, 0x01, 0x00>>
      iex> AutoApi.DoorLocksCommand.to_bin(:lock_unlock_doors, [lock_state: :lock])
      <<0x12, 0x01, 0x01>>
  """
  @spec to_bin(DoorLocksCapability.command_type(), list(any)) :: binary
  def to_bin(:get_lock_state, _args) do
    cmd_id = DoorLocksCapability.command_id(:get_lock_state)
    <<cmd_id>>
  end

  def to_bin(:lock_unlock_doors, lock_state: lock_state) when lock_state in [:lock, :unlock] do
    lock_state_bin = if lock_state == :unlock, do: 0x00, else: 0x01
    cmd_id = DoorLocksCapability.command_id(:lock_unlock_doors)
    <<cmd_id>> <> <<0x01, lock_state_bin>>
  end
end
