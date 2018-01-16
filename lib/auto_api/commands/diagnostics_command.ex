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
defmodule AutoApi.DiagnosticsCommand do
  @moduledoc """
  Handles Diagnostics commands and apply binary commands on `%AutoApi.DiagnosticsState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.DiagnosticsState
  alias AutoApi.DiagnosticsCapability

  @doc """
  Parses the binary command and makes changes or returns the state

        iex> AutoApi.DiagnosticsCommand.execute(%AutoApi.DiagnosticsState{}, <<0x00>>)
        {:state, %AutoApi.DiagnosticsState{}}

        iex> command = <<0x01>> <> <<0x01, 2::integer-16, 100::integer-16>> <> <<0x03, 2::integer-16, 50::integer-16>>
        iex> AutoApi.DiagnosticsCommand.execute(%AutoApi.DiagnosticsState{}, command)
        {:state_changed, %AutoApi.DiagnosticsState{mileage: 100, speed: 50}}

  """
  @spec execute(DiagnosticsState.t(), binary) :: {:state | :state_changed, DiagnosticsState.t()}
  def execute(%DiagnosticsState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%DiagnosticsState{} = state, <<0x01, ds::binary>>) do
    new_state = DiagnosticsState.from_bin(ds)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts VehicleLocation state to capability's state in binary

        iex> AutoApi.DiagnosticsCommand.state(%AutoApi.DiagnosticsState{engine_oil_temperature: 20,engine_rpm: 70, fuel_level: 99, mileage: 2000, speed: 100, washer_fluid_level: :low, tire: []})
        <<1, 12, 0, 4, 0, 0, 0, 0, 8, 0, 4, 0, 0, 0, 0, 11, 0, 4, 0, 0, 0, 0, 7, 0, 4,\
        0, 0, 0, 0, 13, 0, 2, 0, 0, 14, 0, 2, 0, 0, 2, 0, 2, 0, 20, 4, 0, 2, 0, 70, 6,\
        0, 2, 0, 0, 5, 0, 1, 99, 1, 0, 2, 7, 208, 3, 0, 2, 0, 100, 9, 0, 1, 0>>

        iex> AutoApi.DiagnosticsCommand.state(%AutoApi.DiagnosticsState{engine_oil_temperature: 20,engine_rpm: 70, fuel_level: 99, mileage: 2000, speed: 100,washer_fluid_level: :low, tire: [%{tire_position: :front_left, tire_pressure: 1.0}]})
        <<1, 12, 0, 4, 0, 0, 0, 0, 8, 0, 4, 0, 0, 0, 0, 11, 0, 4, 0, 0, 0, 0, 7, 0, 4,\
          0, 0, 0, 0, 13, 0, 2, 0, 0, 14, 0, 2, 0, 0, 2, 0, 2, 0, 20, 4, 0, 2, 0, 70, 6,\
          0, 2, 0, 0, 5, 0, 1, 99, 1, 0, 2, 7, 208, 3, 0, 2, 0, 100, 10, 0, 13, 0, 63,\
          128, 0, 0, 9, 0, 1, 0>>
  """
  @spec state(DiagnosticsState.t()) :: binary
  def state(%DiagnosticsState{} = state) do
    <<0x01, DiagnosticsState.to_bin(state)::binary>>
  end

  @doc """
  Converts command to binary format

      iex> AutoApi.DiagnosticsCommand.to_bin(:get_diagnostics_state, [])
      <<0x00>>
  """
  @spec to_bin(DiagnosticsCapability.command_type(), list(any())) :: binary
  def to_bin(:get_diagnostics_state, []) do
    cmd_id = DiagnosticsCapability.command_id(:get_diagnostics_state)
    <<cmd_id>>
  end
end
