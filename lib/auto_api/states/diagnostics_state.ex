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
            tire: [],
            fuel_volume: 0.0,
            anti_lock_braking: :inactive,
            engine_coolant_temperature: 0,
            engine_total_operating_hours: 0.0,
            engine_total_fuel_consumption: 0.0,
            brake_fluid_level: :filled,
            engine_torque: 0,
            engine_load: 0,
            wheel_based_speed: 0,
            properties: []

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
          tire: list(tire_data),
          fuel_volume: float,
          anti_lock_braking: :inactive | :active,
          engine_coolant_temperature: integer,
          engine_total_operating_hours: float,
          engine_total_fuel_consumption: float,
          brake_fluid_level: :low | :filled,
          engine_torque: integer,
          engine_load: integer,
          wheel_based_speed: integer,
          properties: list(atom)
        }

  @doc """
  Build state based on binary value

  iex> AutoApi.DiagnosticsState.from_bin(<<0x01, 3::integer-16, 100::integer-24>>)
  %AutoApi.DiagnosticsState{mileage: 100}
  iex> AutoApi.DiagnosticsState.from_bin(<<0x01, 3::integer-16, 100::integer-24, 0x09, 1::integer-16, 0x01>>)
  %AutoApi.DiagnosticsState{mileage: 100, washer_fluid_level: :filled}

  iex> AutoApi.DiagnosticsState.from_bin(<<0xA, 11::integer-16, 0x03, 4.0::float-32, 8.0::float-32, 1693::integer-16>>)
  %AutoApi.DiagnosticsState{tire: [%{tire_position: :rear_left, tire_pressure: 4.0, tire_temperature: 8.0, wheel_rpm: 1693}]}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> properties = [:fuel_level, :mileage, :washer_fluid_level]
    iex> AutoApi.DiagnosticsState.to_bin(%AutoApi.DiagnosticsState{engine_oil_temperature: 20,engine_rpm: 70, fuel_level: 99, mileage: 2000, speed: 100, washer_fluid_level: :low, tire: [], properties: properties})
    <<0x05, 1::integer-16, 99>> <> <<0x01, 3::integer-16, 2000::integer-24>> <> <<0x09, 1::integer-16, 0x00>>

    iex> properties = AutoApi.DiagnosticsCapability.properties |> Enum.into(%{}) |> Map.values()
    iex> AutoApi.DiagnosticsState.to_bin(%AutoApi.DiagnosticsState{engine_oil_temperature: 20,engine_rpm: 70, fuel_level: 99, mileage: 2000, speed: 100, washer_fluid_level: :low, tire: [], properties: properties})
    <<0xC, 0x0, 0x4, 0x0, 0x0, 0x0, 0x0, 0x10, 0x0, 0x1, 0x0, 0x8, 0x0, 0x4, 0x0, \
      0x0, 0x0, 0x0, 0xB, 0x0, 0x4, 0x0, 0x0, 0x0, 0x0, 0x14, 0x0, 0x1, 0x1, 0x7, \
      0x0, 0x4, 0x0, 0x0, 0x0, 0x0, 0xD, 0x0, 0x2, 0x0, 0x0, 0xE, 0x0, 0x2, 0x0, \
      0x0, 0x11, 0x0, 0x2, 0x0, 0x0, 0x16, 0x0, 0x1, 0x0, 0x2, 0x0, 0x2, 0x0, 0x14, \
      0x4, 0x0, 0x2, 0x0, 0x46, 0x15, 0x0, 0x1, 0x0, 0x13, 0x0, 0x4, 0x0, 0x0, 0x0, \
      0x0, 0x12, 0x0, 0x4, 0x0, 0x0, 0x0, 0x0, 0x6, 0x0, 0x2, 0x0, 0x0, 0x5, 0x0, \
      0x1, 0x63, 0xF, 0x0, 0x4, 0x0, 0x0, 0x0, 0x0, 0x1, 0x0, 0x3, 0x0, 0x7, 0xD0, \
      0x3, 0x0, 0x2, 0x0, 0x64, 0x9, 0x0, 0x1, 0x0, 0x17, 0x0, 0x2, 0x0, 0x0>>

    iex> tiers = [%{tire_position: :front_left, tire_pressure: 250.00, tire_temperature: 20.00, wheel_rpm: 2900}]
    iex> AutoApi.DiagnosticsState.to_bin(%AutoApi.DiagnosticsState{tire: tiers, properties: [:tire]})
    <<0x0A, 0, 11, 0, 67, 122, 0, 0, 65, 160, 0, 0, 11, 84>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
