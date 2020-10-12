defmodule AutoApi.ChargingStateTest do
  use ExUnit.Case
  doctest AutoApi.ChargingState
  alias AutoApi.{PropertyComponent, ChargingState}

  test "to_bin & from_bin" do
    date = ~U[2019-07-29 10:15:09.654Z]

    state = %ChargingState{
      estimated_range: %PropertyComponent{data: {1000, :kilometers}},
      battery_level: %PropertyComponent{data: 10.001},
      battery_current_ac: %PropertyComponent{data: {10.001, :amperes}},
      battery_current_dc: %PropertyComponent{data: {10.002, :amperes}},
      charger_voltage_ac: %PropertyComponent{data: {10.003, :volts}},
      charger_voltage_dc: %PropertyComponent{data: {10.004, :volts}},
      charge_limit: %PropertyComponent{data: 10.005},
      time_to_complete_charge: %PropertyComponent{data: {10, :hours}},
      charging_rate_kw: %PropertyComponent{data: {10.006, :kilowatts}},
      charge_port_state: %PropertyComponent{data: :closed},
      charge_mode: %PropertyComponent{data: :timer_based},
      max_charging_current: %PropertyComponent{data: {10.007, :amperes}},
      plug_type: %PropertyComponent{data: :type_2},
      charging_window_chosen: %PropertyComponent{data: :chosen},
      departure_times: [
        %PropertyComponent{data: %{state: :inactive, time: %{hour: 1, minute: 2}}}
      ],
      reduction_times: [
        %PropertyComponent{data: %{start_stop: :start, time: %{hour: 1, minute: 2}}}
      ],
      battery_temperature: %PropertyComponent{data: {10.008, :celsius}},
      timers: [%PropertyComponent{data: %{timer_type: :preferred_start_time, date: date}}],
      plugged_in: %PropertyComponent{data: :disconnected},
      status: %PropertyComponent{data: :not_charging},
      charging_rate: %PropertyComponent{data: {10.009, :kilowatts}},
      battery_current: %PropertyComponent{data: {10.010, :milliamperes}},
      charger_voltage: %PropertyComponent{data: {10.011, :millivolts}},
      current_type: %PropertyComponent{data: :alternating_current},
      max_range: %PropertyComponent{data: {40_075, :kilometers}},
      starter_battery_state: %PropertyComponent{data: :yellow},
      smart_charging_status: %PropertyComponent{data: :scc_is_active},
      battery_level_at_departure: %PropertyComponent{data: 0.345},
      preconditioning_departure_status: %PropertyComponent{data: :inactive},
      preconditioning_immediate_status: %PropertyComponent{data: :active},
      preconditioning_departure_enabled: %PropertyComponent{data: :enabled},
      preconditioning_error: %PropertyComponent{data: :available_after_engine_restart}
    }

    new_state =
      state
      |> ChargingState.to_bin()
      |> ChargingState.from_bin()

    assert state == new_state
  end
end
