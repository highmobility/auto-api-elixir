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
defmodule AutoApi.RaceCommand do
  @moduledoc """
  Handles Race commands and apply binary commands on `%AutoApi.RaceState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.RaceState
  alias AutoApi.RaceCapability

  @doc """
  Parses the binary command and makes changes or returns the state

        iex> AutoApi.RaceCommand.execute(%AutoApi.RaceState{}, <<0x00>>)
        {:state, %AutoApi.RaceState{}}

        iex> command = <<0x01>> <> <<0x01, 5::integer-16, 0x03, 9.9::float-32>>
        iex> AutoApi.RaceCommand.execute(%AutoApi.RaceState{}, command)
        {:state_changed, %AutoApi.RaceState{acceleration: [%{g_force: 9.9, type: :rear_lateral_acceleration}]}}

  """
  @spec execute(RaceState.t(), binary) :: {:state | :state_changed, RaceState.t()}
  def execute(%RaceState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%RaceState{} = state, <<0x01, ds::binary>>) do
    new_state = RaceState.from_bin(ds)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts RaceCommand state to capability's state in binary

        iex> properties = [:brake_pressure, :accelerator_pedal_kickdown_switch]
        iex> AutoApi.RaceCommand.state(%AutoApi.RaceState{accelerator_pedal_kickdown_switch: :active, brake_pressure: 80.083, properties: properties})
        <<1, 0x11, 0, 1, 1, 6, 0, 4, 66, 160, 42, 127>>

        iex> properties = AutoApi.RaceCapability.properties |> Enum.into(%{}) |> Map.values()
        iex> AutoApi.RaceCommand.state(%AutoApi.RaceState{acceleration: [%{g_force: 90.19, type: :lateral_acceleration}], properties: properties})
        <<0x1, 0x1, 0x0, 0x5, 0x1, 0x42, 0xB4, 0x61, 0x48, 0x10, 0x0, 0x1, 0x0, 0x11, \
          0x0, 0x1, 0x0, 0x6, 0x0, 0x4, 0x0, 0x0, 0x0, 0x0, 0xF, 0x0, 0x1, 0x0, 0x9, \
          0x0, 0x1, 0x0, 0x4, 0x0, 0x1, 0x0, 0xB, 0x0, 0x1, 0x0, 0x3, 0x0, 0x1, 0x0, \
          0x8, 0x0, 0x1, 0x0, 0xC, 0x0, 0x1, 0x0, 0x5, 0x0, 0x1, 0x0, 0x2, 0x0, 0x1, \
          0x0, 0x7, 0x0, 0x4, 0x0, 0x0, 0x0, 0x0>>
  """
  @spec state(RaceState.t()) :: binary
  def state(%RaceState{} = state) do
    <<0x01, RaceState.to_bin(state)::binary>>
  end

  @doc """
  Converts command to binary format

      iex> AutoApi.RaceCommand.to_bin(:get_race_state, [])
      <<0x00>>
  """
  @spec to_bin(RaceCapability.command_type(), list(any())) :: binary
  def to_bin(:get_race_state, []) do
    cmd_id = RaceCapability.command_id(:get_race_state)
    <<cmd_id>>
  end
end
