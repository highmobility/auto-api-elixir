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
defmodule AutoApiL12.DiagnosticsStateTest do
  use ExUnit.Case, async: true
  alias AutoApiL12.{Property, DiagnosticsState}
  doctest DiagnosticsState

  test "to_bin & from_bin" do
    state = %DiagnosticsState{
      mileage: %Property{data: %{value: 10.0, unit: :miles}},
      engine_oil_temperature: %Property{data: %{value: 2, unit: :kelvin}},
      speed: %Property{data: %{value: 3, unit: :meters_per_second}},
      engine_rpm: %Property{data: %{value: 4, unit: :degrees_per_second}},
      fuel_level: %Property{data: 1.0001},
      estimated_range: %Property{data: %{value: 5, unit: :kilometers}},
      washer_fluid_level: %Property{data: :filled},
      battery_voltage: %Property{data: %{value: 1.003, unit: :volts}},
      adblue_level: %Property{data: 0.95},
      distance_since_reset: %Property{data: %{value: 6, unit: :kilometers}},
      distance_since_start: %Property{data: %{value: 7, unit: :nautical_miles}},
      fuel_volume: %Property{data: %{value: 1.004, unit: :gallons}},
      anti_lock_braking: %Property{data: :inactive},
      engine_coolant_temperature: %Property{data: %{value: 8, unit: :fahrenheit}},
      engine_total_operating_hours: %Property{data: %{value: 1.005, unit: :months}},
      engine_total_fuel_consumption: %Property{data: %{value: 1.006, unit: :liters}},
      brake_fluid_level: %Property{data: :low},
      engine_torque: %Property{data: 1.007},
      engine_load: %Property{data: 1.008},
      wheel_based_speed: %Property{data: %{value: 9, unit: :miles_per_hour}},
      battery_level: %Property{data: 1.009},
      check_control_messages: [
        %Property{
          data: %{
            id: 1,
            remaining_time: %{value: 300, unit: :minutes},
            text: "text",
            status: "status"
          }
        }
      ],
      tire_pressures: [
        %Property{data: %{location: :rear_left, pressure: %{value: 1.009, unit: :bars}}}
      ],
      tire_temperatures: [
        %Property{
          data: %{location: :rear_left_outer, temperature: %{value: 1.010, unit: :kelvin}}
        }
      ],
      wheel_rpms: [
        %Property{
          data: %{location: :rear_right, rpm: %{value: 10, unit: :revolutions_per_minute}}
        }
      ],
      trouble_codes: [
        %Property{
          data: %{
            occurrences: 1,
            id: "id",
            ecu_id: "ecu_id",
            status: "status",
            system: :body
          }
        }
      ],
      mileage_meters: %Property{data: %{value: 11, unit: :meters}},
      odometer: %Property{data: %{value: 11, unit: :meters}},
      engine_total_operating_time: %Property{data: %{value: 11, unit: :hours}},
      tire_pressure_statuses: [
        %Property{data: %{location: :rear_left, status: :alert}}
      ],
      brake_lining_wear_pre_warning: %Property{data: :active},
      engine_oil_life_remaining: %Property{data: 45.56},
      oem_trouble_code_values: [
        %Property{
          data: %{
            id: "id",
            key_value: %{key: "ecu_id", value: "status"}
          }
        }
      ],
      diesel_exhaust_fluid_range: %Property{data: %{value: 11, unit: :meters}},
      diesel_particulate_filter_soot_level: %Property{data: 11.78},
      confirmed_trouble_codes: [
        %Property{
          data: %{
            id: "id",
            ecu_address: "address",
            ecu_variant_name: "variant",
            status: "status"
          }
        }
      ],
      diesel_exhaust_filter_status: %Property{
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
