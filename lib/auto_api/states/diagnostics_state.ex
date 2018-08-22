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
  defstruct mileage: nil,
            engine_oil_temperature: nil,
            speed: nil,
            engine_rpm: nil,
            fuel_level: nil,
            estimated_range: nil,
            current_fuel_consumption: nil,
            average_fuel_consumption: nil,
            washer_fluid_level: nil,
            battery_voltage: nil,
            adblue_level: nil,
            distance_since_reset: nil,
            distance_since_start: nil,
            tire: [],
            fuel_volume: nil,
            anti_lock_braking: nil,
            engine_coolant_temperature: nil,
            engine_total_operating_hours: nil,
            engine_total_fuel_consumption: nil,
            brake_fluid_level: nil,
            engine_torque: nil,
            engine_load: nil,
            wheel_based_speed: nil,
            timestamp: nil,
            properties: []

  use AutoApi.State, spec_file: "specs/diagnostics.json"

  @type t :: %__MODULE__{
          mileage: integer | nil,
          engine_oil_temperature: integer | nil,
          speed: integer | nil,
          engine_rpm: integer | nil,
          fuel_level: integer | nil,
          estimated_range: integer | nil,
          current_fuel_consumption: float | nil,
          average_fuel_consumption: float | nil,
          washer_fluid_level: fluid_level | nil,
          battery_voltage: float | nil,
          adblue_level: float | nil,
          distance_since_reset: integer | nil,
          distance_since_start: integer | nil,
          tire: list(tire_data),
          fuel_volume: float | nil,
          anti_lock_braking: :inactive | :active | nil,
          engine_coolant_temperature: integer | nil,
          engine_total_operating_hours: float | nil,
          engine_total_fuel_consumption: float | nil,
          brake_fluid_level: :low | :filled | nil,
          engine_torque: integer | nil,
          engine_load: integer | nil,
          wheel_based_speed: integer | nil,
          timestamp: DateTime.t() | nil,
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
    <<2, 0, 2, 0, 20, 4, 0, 2, 0, 70, 5, 0, 1, 99, 1, 0, 3, 0, 7, 208, 3, 0, 2, 0, 100, 9, 0, 1, 0>>

    iex> tiers = [%{tire_position: :front_left, tire_pressure: 250.00, tire_temperature: 20.00, wheel_rpm: 2900}]
    iex> AutoApi.DiagnosticsState.to_bin(%AutoApi.DiagnosticsState{tire: tiers, properties: [:tire]})
    <<0x0A, 0, 11, 0, 67, 122, 0, 0, 65, 160, 0, 0, 11, 84>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
