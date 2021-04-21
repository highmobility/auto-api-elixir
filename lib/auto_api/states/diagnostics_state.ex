# AutoAPI
# The MIT License
#
# Copyright (c) 2018- High-Mobility GmbH (https://high-mobility.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
defmodule AutoApi.DiagnosticsState do
  @moduledoc """
  Keeps Diagnostics state

  engine_oil_temperature: Engine oil temperature in Celsius, whereas can be negative
  """

  alias AutoApi.{CommonData, State, UnitType}

  use AutoApi.State, spec_file: "diagnostics.json"

  @type check_control_message :: %{
          id: integer,
          remaining_time: UnitType.duration(),
          text: String.t(),
          status: String.t()
        }

  @type confirmed_trouble_code :: %{
          id: String.t(),
          ecu_address: String.t(),
          ecu_variant_name: String.t(),
          status: String.t()
        }

  @type diesel_exhaust_filter_status :: %{
          status: :unknown | :normal_operation | :overloaded | :at_limit | :over_limit,
          component:
            :unknown
            | :exhaust_filter
            | :diesel_particulate_filter
            | :overboost_code_regulator
            | :off_board_regeneration,
          cleaning: :unknown | :in_progress | :complete | :interrupted
        }

  @type fluid_level :: :low | :filled

  @type location_wheel ::
          :front_left
          | :front_right
          | :rear_right
          | :rear_left
          | :rear_right_outer
          | :rear_left_outer
          | :spare

  @type oem_trouble_code_value :: %{
          id: String.t(),
          key_value: %{
            key: String.t(),
            value: String.t()
          }
        }

  @type tire_pressure :: %{
          location: location_wheel(),
          pressure: UnitType.pressure()
        }

  @type tire_pressure_status :: %{
          location: location_wheel(),
          status: :normal | :low | :alert
        }

  @type tire_temperature :: %{
          location: location_wheel(),
          temperature: UnitType.temperature()
        }

  @type trouble_code :: %{
          occurrences: integer,
          id: String.t(),
          ecu_id: String.t(),
          status: String.t(),
          system: :unknown | :body | :chassis | :powertrain | :network
        }

  @type wheel_rpm :: %{
          location: location_wheel(),
          rpm: UnitType.angular_velocity()
        }

  @type t :: %__MODULE__{
          # Deprecated
          mileage: State.property(UnitType.length()),
          engine_oil_temperature: State.property(UnitType.temperature()),
          speed: State.property(UnitType.speed()),
          engine_rpm: State.property(UnitType.angular_velocity()),
          fuel_level: State.property(float),
          estimated_range: State.property(UnitType.length()),
          washer_fluid_level: State.property(fluid_level()),
          battery_voltage: State.property(UnitType.electric_potential_difference()),
          adblue_level: State.property(float),
          distance_since_reset: State.property(UnitType.length()),
          distance_since_start: State.property(UnitType.length()),
          fuel_volume: State.property(UnitType.volume()),
          anti_lock_braking: State.property(CommonData.activity()),
          engine_coolant_temperature: State.property(UnitType.temperature()),
          # Deprecated
          engine_total_operating_hours: State.property(UnitType.duration()),
          engine_total_fuel_consumption: State.property(UnitType.volume()),
          brake_fluid_level: State.property(fluid_level()),
          engine_torque: State.property(float),
          engine_load: State.property(float),
          wheel_based_speed: State.property(UnitType.length()),
          battery_level: State.property(float),
          check_control_messages: State.multiple_property(check_control_message()),
          tire_pressures: State.multiple_property(tire_pressure()),
          tire_temperatures: State.multiple_property(tire_temperature()),
          wheel_rpms: State.multiple_property(wheel_rpm()),
          trouble_codes: State.multiple_property(trouble_code()),
          # Deprecated
          mileage_meters: State.property(UnitType.length()),
          odometer: State.property(UnitType.length()),
          engine_total_operating_time: State.property(UnitType.duration()),
          tire_pressure_statuses: State.multiple_property(tire_pressure_status()),
          brake_lining_wear_pre_warning: State.property(CommonData.activity()),
          engine_oil_life_remaining: State.property(float),
          oem_trouble_code_values: State.multiple_property(oem_trouble_code_value()),
          diesel_exhaust_fluid_range: State.property(UnitType.length()),
          diesel_particulate_filter_soot_level: State.property(float),
          confirmed_trouble_codes: State.multiple_property(confirmed_trouble_code()),
          diesel_exhaust_filter_status: State.property(diesel_exhaust_filter_status())
        }

  @doc """
  Build state based on binary value

    iex> bin = <<22, 0, 11, 1, 0, 8, 64, 40, 0, 0, 0, 0, 0, 0>>
    iex> AutoApi.DiagnosticsState.from_bin(bin)
    %AutoApi.DiagnosticsState{engine_load: %AutoApi.Property{data: 12.0}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> state = %AutoApi.DiagnosticsState{engine_load: %AutoApi.Property{data: 12}}
    iex> AutoApi.DiagnosticsState.to_bin(state)
    <<22, 0, 11, 1, 0, 8, 64, 40, 0, 0, 0, 0, 0, 0>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
