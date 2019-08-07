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
defmodule AutoApi.DoorsCommand do
  @moduledoc """
  Handles  commands and apply binary commands on `%AutoApi.DoorsState{}`
  """
  use AutoApi.Command

  alias AutoApi.{DoorsState, PropertyComponent}

  @lock_unlock_doors_spec %{
    "type" => "enum",
    "size" => 1,
    "values" => [%{"id" => 0, "name" => "unlock"}, %{"id" => 1, "name" => "lock"}]
  }

  @doc """
  Parses the binary command and makes changes or returns the state

        iex> AutoApi.DoorsCommand.execute(%AutoApi.DoorsState{}, <<0x00>>)
        {:state, %AutoApi.DoorsState{}}

        iex> command = <<0x01>> <> <<0x03, 2::integer-16, 0x01, 0x01>> <> <<0x03, 2::integer-16, 0x00, 0x00>>
        iex> AutoApi.DoorsCommand.execute(%AutoApi.DoorsState{}, command)
        {:state_changed, %AutoApi.DoorsState{locks: [%{door_location: :front_left, lock_state: :unlocked}, %{door_location: :front_right, lock_state: :locked}]}}

  """
  @spec execute(DoorsState.t(), binary) :: {:state | :state_changed, DoorsState.t()}
  def execute(%DoorsState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%DoorsState{} = state, <<0x01, ds::binary>>) do
    new_state = DoorsState.from_bin(ds)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  def execute(
        %DoorsState{} = state,
        <<0x12, 0x01, prop_comp_size::integer-16, lock_comp_prop::binary-size(prop_comp_size)>>
      ) do
    lock_command = PropertyComponent.to_struct(lock_comp_prop, @lock_unlock_doors_spec)
    lock_state = if lock_command.data == :unlock, do: :unlocked, else: :locked

    locks =
      Enum.map(state.locks, fn prop_comp ->
        put_in(prop_comp.data.lock_state, lock_state)
      end)

    new_state = %{state | locks: locks}

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts DoorsCommand state to capability's state in binary

        iex> AutoApi.DoorsCommand.state(%AutoApi.DoorsState{positions: [%{door_location: :front_left, position: :closed}], properties: [:positions]})
        <<1, 4, 0, 2, 0, 0>>
  """
  @spec state(DoorsState.t()) :: binary
  def state(%DoorsState{} = state) do
    <<0x01, DoorsState.to_bin(state)::binary>>
  end
end
