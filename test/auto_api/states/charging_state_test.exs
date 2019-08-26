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
defmodule AutoApi.ChargingStateTest do
  use ExUnit.Case
  doctest AutoApi.ChargingState
  alias AutoApi.{PropertyComponent, ChargingState}

  test "to_bin & from_bin" do
    date = ~U[2019-07-29 10:15:09.654Z]
    state = %ChargingState{
      estimated_range: %PropertyComponent{data: 1000},
      battery_level: %PropertyComponent{data: 10.001},
      battery_current_ac: %PropertyComponent{data: 10.001},
      battery_current_dc: %PropertyComponent{data: 10.002},
      charger_voltage_ac: %PropertyComponent{data: 10.003},
      charger_voltage_dc: %PropertyComponent{data: 10.004},
      charge_limit: %PropertyComponent{data: 10.005},
      time_to_complete_charge: %PropertyComponent{data: 10},
      charging_rate_kw: %PropertyComponent{data: 10.006},
      charge_port_state: %PropertyComponent{data: :closed},
      charge_mode: %PropertyComponent{data: :timer_based},
      max_charging_current: %PropertyComponent{data: 10.007},
      plug_type: %PropertyComponent{data: :type_2},
      charging_window_chosen: %PropertyComponent{data: :chosen},
      departure_times: [%PropertyComponent{data: %{state: :inactive, time: %{hour: 1, minute: 2}}}],
      reduction_times: [%PropertyComponent{data: %{start_stop: :start, time: %{hour: 1, minute: 2}}}],
      battery_temperature: %PropertyComponent{data: 10.008},
      timers: [%PropertyComponent{data: %{timer_type: :preferred_start_time, date: date}}],
      plugged_in: %PropertyComponent{data: :disconnected},
      charging_state: %PropertyComponent{data: :not_charging}
    }

    new_state =
      state
      |> ChargingState.to_bin()
      |> ChargingState.from_bin()

    assert state == new_state
  end
end
