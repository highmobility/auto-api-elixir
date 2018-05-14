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
defmodule AutoApi.TrunkCommand do
  @moduledoc """
  Handles  commands and apply binary commands on `%AutoApi.TrunkState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.TrunkState
  alias AutoApi.TrunkCapability

  @doc """
  Parses the binary command and makes changes or returns the state

        iex> AutoApi.TrunkCommand.execute(%AutoApi.TrunkState{}, <<0x00>>)
        {:state, %AutoApi.TrunkState{}}

        iex> command = <<0x01>> <> <<0x01, 1::integer-16, 0x00>> <> <<0x02, 1::integer-16, 0x00>>
        iex> AutoApi.TrunkCommand.execute(%AutoApi.TrunkState{}, command)
        {:state_changed, %AutoApi.TrunkState{trunk_lock: :unlocked, trunk_position: :closed}}

        iex> AutoApi.TrunkCommand.execute(%AutoApi.TrunkState{}, <<0x02, 0x01, 1::integer-16, 0x00>>)
        {:state_changed, %AutoApi.TrunkState{trunk_lock: :unlocked}}

        iex> AutoApi.TrunkCommand.execute(%AutoApi.TrunkState{}, <<0x02, 0x02, 1::integer-16, 0x01>>)
        {:state_changed, %AutoApi.TrunkState{trunk_position: :open}}

        iex> AutoApi.TrunkCommand.execute(%AutoApi.TrunkState{}, <<0x02, 0x02, 1::integer-16, 0x01, 0x01, 1::integer-16, 0x00>>)
        {:state_changed, %AutoApi.TrunkState{trunk_position: :open, trunk_lock: :unlocked}}

        iex> AutoApi.DoorLocksCommand.execute(%AutoApi.DoorLocksState{door: [%{door_location: :front_left, door_lock: :unlocked, door_position: :closed}]}, <<0x02, 0x01>>)
        {:state_changed, %AutoApi.DoorLocksState{door: [%{door_location: :front_left, door_lock: :locked, door_position: :closed}]}}
  """
  @spec execute(TrunkState.t(), binary) :: {:state | :state_changed, TrunkState.t()}
  def execute(%TrunkState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%TrunkState{} = state, <<0x01, ds::binary>>) do
    new_state = TrunkState.from_bin(ds)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  def execute(%TrunkState{} = state, <<0x02, commands::binary>>) do
    cmd_state = TrunkState.from_bin(commands)

    new_state = %{
      state
      | trunk_lock: cmd_state.trunk_lock,
        trunk_position: cmd_state.trunk_position
    }

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts DoorLocksCommand state to capability's state in binary

        iex> AutoApi.TrunkCommand.state(%AutoApi.TrunkState{properties: [:trunk_lock, :trunk_position]})
        <<1, 1, 0, 1, 1, 2, 0, 1, 0>>
  """
  @spec state(TrunkState.t()) :: binary
  def state(%TrunkState{} = state) do
    <<0x01, TrunkState.to_bin(state)::binary>>
  end

  @doc """
  Returns binary command
      iex> AutoApi.TrunkCommand.to_bin(:get_trunk_state, [])
      <<0x00>>

      iex> AutoApi.TrunkCommand.to_bin(:open_close_trunk, [:unlock, :close])
      <<2, 1, 0, 1, 0, 2, 0, 1, 0>>

      iex> AutoApi.TrunkCommand.to_bin(:open_close_trunk, [nil, :open])
      <<2, 2, 0, 1, 1>>

      iex> AutoApi.TrunkCommand.to_bin(:open_close_trunk, [:lock, nil])
      <<2, 1, 0, 1, 1>>
  """
  @spec to_bin(TrunkCapability.command_type(), list(any)) :: binary
  def to_bin(:get_trunk_state, _args) do
    cmd_id = TrunkCapability.command_id(:get_trunk_state)
    <<cmd_id>>
  end

  def to_bin(:open_close_trunk, [new_lock_state, new_position_state])
      when new_lock_state in [:lock, :unlock, nil] and new_position_state in [:close, :open, nil] do
    cmd_id = TrunkCapability.command_id(:open_close_trunk)

    lock_bin =
      case new_lock_state do
        :unlock ->
          <<0x01, 1::integer-16, 0x00>>

        :lock ->
          <<0x01, 1::integer-16, 0x01>>

        _ ->
          <<>>
      end

    pos_bin =
      case new_position_state do
        :close ->
          <<0x02, 1::integer-16, 0x00>>

        :open ->
          <<0x02, 1::integer-16, 0x01>>

        _ ->
          <<>>
      end

    <<cmd_id>> <> lock_bin <> pos_bin
  end
end
