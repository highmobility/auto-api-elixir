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
defmodule AutoApi.DiagnosticsState do
  @moduledoc """
  Keeps Diagnostics state

  engine_oil_temperature: Engine oil temperature in Celsius, whereas can be negative
  """

  @type fluid_level :: :low | :filled
  @type position :: :front_left | :front_right | :rear_right | :rear_left
  @type tire_data :: %{position: position, pressure: float}
  @doc """
  Diagnostics state
  """
  defstruct mileage: 0,
            engine_oil_temperature: 0,
            speed: 0,
            engine_rpm: 0,
            fuel_level: 0,
            estimated_range: 0,
            current_fuel_consumption: 0.0,
            average_fuel_consumption: 0.0,
            washer_fluid_level: :low,
            battery_voltage: 0.0,
            adblue_level: 0.0,
            distance_since_reset: 0,
            distance_since_start: 0,
            tire: []

  use AutoApi.State, spec_file: "specs/diagnostics.json"

  @type t :: %__MODULE__{
          mileage: integer,
          engine_oil_temperature: integer,
          speed: integer,
          engine_rpm: integer,
          fuel_level: integer,
          estimated_range: integer,
          current_fuel_consumption: float,
          average_fuel_consumption: float,
          washer_fluid_level: fluid_level,
          battery_voltage: float,
          adblue_level: float,
          distance_since_reset: integer,
          distance_since_start: integer,
          tire: list(tire_data)
        }

  @doc """
  Build state based on binary value

  iex> AutoApi.DiagnosticsState.from_bin(<<0x01, 2::integer-16, 100::integer-16>>)
  %AutoApi.DiagnosticsState{mileage: 100}
  iex> AutoApi.DiagnosticsState.from_bin(<<0x01, 2::integer-16, 100::integer-16, 0x09, 1::integer-16, 0x01>>)
  %AutoApi.DiagnosticsState{mileage: 100, washer_fluid_level: :filled}

  iex> AutoApi.DiagnosticsState.from_bin(<<0xA, 13::integer-16, 0x03, 4.0::float-32, 8.0::float-32, 169330::integer-32>>)
  %AutoApi.DiagnosticsState{tire: [%{tire_position: :rear_left, tire_pressure: 4.0, tire_temperature: 8.0, wheel_rpm: 169330}]}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> AutoApi.DiagnosticsState.to_bin(%AutoApi.DiagnosticsState{engine_oil_temperature: 20,engine_rpm: 70, fuel_level: 99, mileage: 2000, speed: 100, washer_fluid_level: :low, tire: []})
    <<12, 0, 4, 0, 0, 0, 0, 8, 0, 4, 0, 0, 0, 0, 11, 0, 4, 0, 0, 0, 0, 7, 0, 4, 0, \
    0, 0, 0, 13, 0, 2, 0, 0, 14, 0, 2, 0, 0, 2, 0, 2, 0, 20, 4, 0, 2, 0, 70, 6, 0, \
    2, 0, 0, 5, 0, 1, 99, 1, 0, 2, 7, 208, 3, 0, 2, 0, 100, 9, 0, 1, 0>>
    iex> tiers = [%{tire_position: :front_lef, tire_pressure: 250.00, tire_temperature: 20.00, wheel_rpm: 2900}]
    iex> AutoApi.DiagnosticsState.to_bin(%AutoApi.DiagnosticsState{tire: tiers})
    <<12, 0, 4, 0, 0, 0, 0, 8, 0, 4, 0, 0, 0, 0, 11, 0, 4, 0, 0, 0, 0, 7, 0, 4, 0, \
    0, 0, 0, 13, 0, 2, 0, 0, 14, 0, 2, 0, 0, 2, 0, 2, 0, 0, 4, 0, 2, 0, 0, 6, 0, \
    2, 0, 0, 5, 0, 1, 0, 1, 0, 2, 0, 0, 3, 0, 2, 0, 0, 10, 0, 13, 67, 122, 0, 0, \
    65, 160, 0, 0, 0, 0, 11, 84, 9, 0, 1, 0>>

  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
