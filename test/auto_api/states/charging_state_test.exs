defmodule AutoApiL11.ChargingStateTest do
  use ExUnit.Case
  doctest AutoApiL11.ChargingState
  alias AutoApiL11.{PropertyComponent, ChargingState}

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
      departure_times: [
        %PropertyComponent{data: %{state: :inactive, time: %{hour: 1, minute: 2}}}
      ],
      reduction_times: [
        %PropertyComponent{data: %{start_stop: :start, time: %{hour: 1, minute: 2}}}
      ],
      battery_temperature: %PropertyComponent{data: 10.008},
      timers: [%PropertyComponent{data: %{timer_type: :preferred_start_time, date: date}}],
      plugged_in: %PropertyComponent{data: :disconnected},
      status: %PropertyComponent{data: :not_charging}
    }

    new_state =
      state
      |> ChargingState.to_bin()
      |> ChargingState.from_bin()

    assert state == new_state
  end
end
