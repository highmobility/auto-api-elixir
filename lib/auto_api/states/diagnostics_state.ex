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
            washer_fluid_level: nil,
            battery_voltage: nil,
            adblue_level: nil,
            distance_since_reset: nil,
            distance_since_start: nil,
            fuel_volume: nil,
            anti_lock_braking: nil,
            engine_coolant_temperature: nil,
            engine_total_operating_hours: nil,
            engine_total_fuel_consumption: nil,
            brake_fluid_level: nil,
            engine_torque: nil,
            engine_load: nil,
            wheel_based_speed: nil,
            battery_level: nil,
            check_control_messages: [],
            tire_pressures: [],
            timestamp: nil,
            properties: []

  use AutoApi.State, spec_file: "specs/diagnostics.json"

  @type check_control_message :: %{
          id: integer,
          remaining_minutes: integer,
          text_size: integer,
          text: String.t(),
          status: String.t()
        }
  @type tire_pressure :: %{
          location: :front_left | :front_right | :rear_right | :rear_left,
          pressure: float
        }

  @type t :: %__MODULE__{
          mileage: integer | nil,
          engine_oil_temperature: integer | nil,
          speed: integer | nil,
          engine_rpm: integer | nil,
          fuel_level: integer | nil,
          estimated_range: integer | nil,
          washer_fluid_level: fluid_level | nil,
          battery_voltage: float | nil,
          adblue_level: float | nil,
          distance_since_reset: integer | nil,
          distance_since_start: integer | nil,
          fuel_volume: float | nil,
          anti_lock_braking: :inactive | :active | nil,
          engine_coolant_temperature: integer | nil,
          engine_total_operating_hours: float | nil,
          engine_total_fuel_consumption: float | nil,
          brake_fluid_level: :low | :filled | nil,
          engine_torque: integer | nil,
          engine_load: integer | nil,
          wheel_based_speed: integer | nil,
          battery_level: integer | nil,
          check_control_messages: list(check_control_message),
          tire_pressures: list(tire_pressure),
          timestamp: DateTime.t() | nil,
          properties: list(atom)
        }

  @doc """
  Build state based on binary value

    iex> AutoApi.DiagnosticsState.from_bin(<<0x01, 3::integer-16, 100::integer-24>>)
    %AutoApi.DiagnosticsState{mileage: 100}
    iex> AutoApi.DiagnosticsState.from_bin(<<0x01, 3::integer-16, 100::integer-24, 0x09, 1::integer-16, 0x01>>)
    %AutoApi.DiagnosticsState{mileage: 100, washer_fluid_level: :filled}

    iex> state_bin = <<25, 0, 12, 0, 3, 0, 0, 0, 2, 0, 1, 116, 0, 1, 115>>
    iex> AutoApi.DiagnosticsState.from_bin(state_bin)
    %AutoApi.DiagnosticsState{check_control_messages: [%{id: 3, remaining_minutes: 2, status: "s", status_size: 1, text: "t", text_size: 1}]}

  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin


    iex> properties = [:check_control_messages]
    iex> check_control_messages = [%{id: 1, remaining_minutes: 4, text: "text", status: "status"}]
    iex> AutoApi.DiagnosticsState.to_bin(%AutoApi.DiagnosticsState{check_control_messages: check_control_messages, properties: properties})
    <<25, 0, 20, 0, 1, 0, 0, 0, 4, 0, 4, 116, 101, 120, 116, 0, 6, 115, 116, 97, 116, 117, 115>>

    iex> properties = [:fuel_level, :mileage, :washer_fluid_level]
    iex> AutoApi.DiagnosticsState.to_bin(%AutoApi.DiagnosticsState{engine_oil_temperature: 20,engine_rpm: 70, fuel_level: 99, mileage: 2000, speed: 100, washer_fluid_level: :low, properties: properties})
    <<0x05, 1::integer-16, 99>> <> <<0x01, 3::integer-16, 2000::integer-24>> <> <<0x09, 1::integer-16, 0x00>>

    iex> properties = AutoApi.DiagnosticsCapability.properties |> Enum.into(%{}) |> Map.values()
    iex> AutoApi.DiagnosticsState.to_bin(%AutoApi.DiagnosticsState{engine_oil_temperature: 20,engine_rpm: 70, fuel_level: 99, mileage: 2000, speed: 100, washer_fluid_level: :low, properties: properties})
    <<2, 0, 2, 0, 20, 4, 0, 2, 0, 70, 5, 0, 1, 99, 1, 0, 3, 0, 7, 208, 3, 0, 2, 0, 100, 9, 0, 1, 0>>

  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
