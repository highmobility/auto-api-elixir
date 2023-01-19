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
defmodule AutoApi.ChargingStateTest do
  use ExUnit.Case, async: true
  doctest AutoApi.ChargingState
  alias AutoApi.{Property, ChargingState}

  test "to_bin & from_bin" do
    date = ~U[2019-07-29 10:15:09.654Z]

    state = %ChargingState{
      estimated_range: %Property{data: %{value: 1000, unit: :kilometers}},
      battery_level: %Property{data: 10.001},
      battery_current_ac: %Property{data: %{value: 10.001, unit: :amperes}},
      battery_current_dc: %Property{data: %{value: 10.002, unit: :amperes}},
      charger_voltage_ac: %Property{data: %{value: 10.003, unit: :volts}},
      charger_voltage_dc: %Property{data: %{value: 10.004, unit: :volts}},
      charge_limit: %Property{data: 10.005},
      time_to_complete_charge: %Property{data: %{value: 10, unit: :hours}},
      charging_rate_kw: %Property{data: %{value: 10.006, unit: :kilowatts}},
      charge_port_state: %Property{data: :closed},
      charge_mode: %Property{data: :timer_based},
      max_charging_current: %Property{data: %{value: 10.007, unit: :amperes}},
      plug_type: %Property{data: :type_2},
      charging_window_chosen: %Property{data: :chosen},
      departure_times: [
        %Property{data: %{state: :inactive, time: %{hour: 1, minute: 2}}}
      ],
      reduction_times: [
        %Property{data: %{start_stop: :start, time: %{hour: 1, minute: 2}}}
      ],
      battery_temperature: %Property{data: %{value: 10.008, unit: :celsius}},
      timers: [%Property{data: %{timer_type: :preferred_start_time, date: date}}],
      plugged_in: %Property{data: :disconnected},
      status: %Property{data: :not_charging},
      charging_rate: %Property{data: %{value: 10.009, unit: :kilowatts}},
      battery_current: %Property{data: %{value: 10.010, unit: :milliamperes}},
      charger_voltage: %Property{data: %{value: 10.011, unit: :millivolts}},
      current_type: %Property{data: :alternating_current},
      max_range: %Property{data: %{value: 40_075, unit: :kilometers}},
      starter_battery_state: %Property{data: :yellow},
      smart_charging_status: %Property{data: :scc_is_active},
      battery_level_at_departure: %Property{data: 0.345},
      preconditioning_departure_status: %Property{data: :inactive},
      preconditioning_immediate_status: %Property{data: :active},
      preconditioning_departure_enabled: %Property{data: :enabled},
      preconditioning_error: %Property{data: :available_after_engine_restart},
      battery_capacity: %Property{data: %{value: 45.456, unit: :kilowatt_hours}},
      driving_mode_phev: %Property{data: :hybrid_parallel},
      battery_charge_type: %Property{data: :no_charge}
    }

    new_state =
      state
      |> ChargingState.to_bin()
      |> ChargingState.from_bin()

    assert state == new_state
  end
end
