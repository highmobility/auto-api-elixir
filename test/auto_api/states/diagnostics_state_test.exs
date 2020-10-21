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
defmodule AutoApi.DiagnosticsStateTest do
  use ExUnit.Case
  alias AutoApi.{PropertyComponent, DiagnosticsState}
  doctest DiagnosticsState

  test "to_bin & from_bin" do
    state = %DiagnosticsState{
      mileage: %PropertyComponent{data: {10.0, :miles}},
      engine_oil_temperature: %PropertyComponent{data: {2, :kelvin}},
      speed: %PropertyComponent{data: {3, :meters_per_second}},
      engine_rpm: %PropertyComponent{data: {4, :degrees_per_second}},
      fuel_level: %PropertyComponent{data: 1.0001},
      estimated_range: %PropertyComponent{data: {5, :kilometers}},
      washer_fluid_level: %PropertyComponent{data: :filled},
      battery_voltage: %PropertyComponent{data: {1.003, :volts}},
      adblue_level: %PropertyComponent{data: {1.003, :liters}},
      distance_since_reset: %PropertyComponent{data: {6, :kilometers}},
      distance_since_start: %PropertyComponent{data: {7, :nautical_miles}},
      fuel_volume: %PropertyComponent{data: {1.004, :gallons}},
      anti_lock_braking: %PropertyComponent{data: :inactive},
      engine_coolant_temperature: %PropertyComponent{data: {8, :fahrenheit}},
      engine_total_operating_hours: %PropertyComponent{data: {1.005, :months}},
      engine_total_fuel_consumption: %PropertyComponent{data: {1.006, :liters}},
      brake_fluid_level: %PropertyComponent{data: :low},
      engine_torque: %PropertyComponent{data: 1.007},
      engine_load: %PropertyComponent{data: 1.008},
      wheel_based_speed: %PropertyComponent{data: {9, :miles_per_hour}},
      battery_level: %PropertyComponent{data: 1.009},
      check_control_messages: [
        %PropertyComponent{
          data: %{
            id: 1,
            remaining_time: {300, :minutes},
            text: "text",
            status: "status"
          }
        }
      ],
      tire_pressures: [
        %PropertyComponent{data: %{location: :rear_left, pressure: {1.009, :bars}}}
      ],
      tire_temperatures: [
        %PropertyComponent{data: %{location: :rear_left_outer, temperature: {1.010, :kelvin}}}
      ],
      wheel_rpms: [
        %PropertyComponent{data: %{location: :rear_right, rpm: {10, :revolutions_per_minute}}}
      ],
      trouble_codes: [
        %PropertyComponent{
          data: %{
            occurrences: 1,
            id: "id",
            ecu_id: "ecu_id",
            status: "status",
            system: :body
          }
        }
      ],
      mileage_meters: %PropertyComponent{data: {11, :meters}},
      odometer: %PropertyComponent{data: {11, :meters}},
      engine_total_operating_time: %PropertyComponent{data: {11, :hours}},
      tire_pressure_statuses: [
        %PropertyComponent{data: %{location: :rear_left, status: :alert}}
      ],
      brake_lining_wear_pre_warning: %PropertyComponent{data: :active},
      engine_oil_life_remaining: %PropertyComponent{data: 45.56},
      oem_trouble_code_values: [
        %PropertyComponent{
          data: %{
            id: "id",
            key_value: %{key: "ecu_id", value: "status"}
          }
        }
      ],
      diesel_exhaust_fluid_range: %PropertyComponent{data: {11, :meters}},
      diesel_particulate_filter_soot_level: %PropertyComponent{data: 11.78},
      confirmed_trouble_codes: [
        %PropertyComponent{
          data: %{
            id: "id",
            ecu_address: "address",
            ecu_variant_name: "variant",
            status: "status"
          }
        }
      ],
      diesel_exhaust_filter_status: %PropertyComponent{
        data: %{
          status: :at_limit,
          component: :diesel_particulate_filter,
          cleaning: :interrupted
        }
      }
    }

    new_state =
      state
      |> DiagnosticsState.to_bin()
      |> DiagnosticsState.from_bin()

    assert new_state == state
  end
end
