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

        iex> command = <<0x01>> <> <<0x01, 3::integer-16, 0x03, 0x01, 0x01>> <> <<0x01, 3::integer-16, 0x00, 0x00, 0x00>>
        iex> AutoApi.DoorLocksCommand.execute(%AutoApi.DoorLocksState{}, command)
        {:state_changed, %AutoApi.DoorLocksState{door: [%{door_location: :front_left, door_lock: :unlocked, door_position: :closed}, %{door_location: :rear_left, door_lock: :locked, door_position: :open}]}}

        iex> AutoApi.DoorLocksCommand.execute(%AutoApi.DoorLocksState{door: [%{door_location: :front_left, door_lock: :locked, door_position: :closed}]}, <<0x02, 0x00>>)
        {:state_changed, %AutoApi.DoorLocksState{door: [%{door_location: :front_left, door_lock: :unlocked, door_position: :closed}]}}

        iex> AutoApi.DoorLocksCommand.execute(%AutoApi.DoorLocksState{door: [%{door_location: :front_left, door_lock: :unlocked, door_position: :closed}]}, <<0x02, 0x01>>)
        {:state_changed, %AutoApi.DoorLocksState{door: [%{door_location: :front_left, door_lock: :locked, door_position: :closed}]}}
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

  def execute(%DoorLocksState{} = state, <<0x02, lock_cmd>>) do
    door_lock = if(lock_cmd == 0x00, do: :unlocked, else: :locked)

    door = Enum.map(state.door, fn door -> %{door | door_lock: door_lock} end)

    new_state = %{state | door: door}

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts DoorLocksCommand state to capability's state in binary

        iex> AutoApi.DoorLocksCommand.state(%AutoApi.DoorLocksState{door: [%{door_location: :front_left, door_lock: :unlocked, door_position: :closed}], properties: [:door]})
        <<1, 1, 0, 3, 0, 0, 0>>
  """
  @spec state(DoorLocksState.t()) :: binary
  def state(%DoorLocksState{} = state) do
    <<0x01, DoorLocksState.to_bin(state)::binary>>
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
  @spec to_bin(DoorLocksCapability.command_type(), list(any)) :: binary
  def to_bin(:get_lock_state, _args) do
    cmd_id = DoorLocksCapability.command_id(:get_lock_state)
    <<cmd_id>>
  end

  def to_bin(:lock_unlock_doors, [new_lock_state]) when new_lock_state in [:lock, :unlock] do
    cmd_id = DoorLocksCapability.command_id(:lock_unlock_doors)
    lock_bin = if(new_lock_state == :unlock, do: 0x00, else: 0x01)
    <<cmd_id, lock_bin>>
  end
end
