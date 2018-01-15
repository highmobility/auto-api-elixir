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

        ie> command = <<0x01>> <> <<0x01,
        ie> AutoApi.DiagnosticsCommand.execute(%AutoApi.DiagnosticsState{}, command)
        {:state_changed, %AutoApi.DiagnosticsState{engine_oil_temperature: 20,engine_rpm: 70, fuel_level: 99, mileage: 2000, speed: 100,washer_fluid_level: :low, tires: [%{position: :front_left, pressure: 20.79}]}}

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

        ie> AutoApi.DiagnosticsCommand.state(%AutoApi.DiagnosticsState{engine_oil_temperature: 20,engine_rpm: 70, fuel_level: 99, mileage: 2000, speed: 100,washer_fluid_level: :low, tires: []})
        <<0x01, 2000::integer-24, 20::integer-16, 100::integer-16, 70::integer-16, 99::integer-8, 0x00, 0x00>>
        ie> AutoApi.DiagnosticsCommand.state(%AutoApi.DiagnosticsState{engine_oil_temperature: 20,engine_rpm: 70, fuel_level: 99, mileage: 2000, speed: 100,washer_fluid_level: :low, tires: [%{position: :front_left, pressure: 1.0}]})
        <<0x01, 2000::integer-24, 20::integer-16, 100::integer-16, 70::integer-16, 99::integer-8, 0x00, 0x01, 0x0, 1.0::float-32>>
  """
  @spec state(DiagnosticsState.t()) :: <<_::88>>
  def state(%DiagnosticsState{} = state) do
    <<0x01, DiagnosticsState.to_bin(state)::binary>>
  end

  @doc """
  Converts VehicleLocation state to capability's vehicle state binary

        ie> AutoApi.DiagnosticsCommand.vehicle_state(%AutoApi.DiagnosticsState{engine_oil_temperature: 20,engine_rpm: 70, fuel_level: 99, mileage: 2000, speed: 100,washer_fluid_level: :low, tires: [%{position: :front_left, pressure: 1.0}]})
        <<0x0B, 2000::integer-24, 20::integer-16, 100::integer-16, 70::integer-16, 99::integer-8, 0x00>>
  """
  @spec vehicle_state(DiagnosticsState.t()) :: binary
  def vehicle_state(%DiagnosticsState{} = state) do
    <<0x0B, DiagnosticsState.to_bin(state)::binary-size(0x0B)>>
  end

  @doc """
  Converts command to binary format

      ie> AutoApi.DiagnosticsCommand.to_bin(:get_diagnostics_state, [])
      <<0x00>>
  """
  @spec to_bin(DiagnosticsCapability.command_type(), list(any())) :: binary
  def to_bin(:get_diagnostics_state, []) do
    cmd_id = DiagnosticsCapability.command_id(:get_diagnostics_state)
    <<cmd_id>>
  end
end
