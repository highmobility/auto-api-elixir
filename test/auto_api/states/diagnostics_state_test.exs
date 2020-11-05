defmodule AutoApiL11.DiagnosticsStateTest do
  use ExUnit.Case
  alias AutoApiL11.{PropertyComponent, DiagnosticsState}
  doctest DiagnosticsState

  test "to_bin & from_bin" do
    state = %DiagnosticsState{
      mileage: %PropertyComponent{data: 10},
      engine_oil_temperature: %PropertyComponent{data: 2},
      speed: %PropertyComponent{data: 3},
      engine_rpm: %PropertyComponent{data: 4},
      fuel_level: %PropertyComponent{data: 1.0001},
      estimated_range: %PropertyComponent{data: 5},
      washer_fluid_level: %PropertyComponent{data: :filled},
      battery_voltage: %PropertyComponent{data: 1.003},
      distance_since_reset: %PropertyComponent{data: 6},
      distance_since_start: %PropertyComponent{data: 7},
      fuel_volume: %PropertyComponent{data: 1.004},
      anti_lock_braking: %PropertyComponent{data: :inactive},
      engine_coolant_temperature: %PropertyComponent{data: 8},
      engine_total_operating_hours: %PropertyComponent{data: 1.005},
      engine_total_fuel_consumption: %PropertyComponent{data: 1.006},
      brake_fluid_level: %PropertyComponent{data: :low},
      engine_torque: %PropertyComponent{data: 1.007},
      engine_load: %PropertyComponent{data: 1.008},
      wheel_based_speed: %PropertyComponent{data: 9},
      battery_level: %PropertyComponent{data: 1.009},
      check_control_messages: [
        %PropertyComponent{
          data: %{
            id: 1,
            remaining_minutes: 300,
            text: "text",
            status: "status"
          }
        }
      ],
      tire_pressures: [%PropertyComponent{data: %{location: :rear_left, pressure: 1.009}}],
      tire_temperatures: [%PropertyComponent{data: %{location: :rear_left, temperature: 1.010}}],
      wheel_rpms: [%PropertyComponent{data: %{location: :rear_right, rpm: 10}}],
      trouble_codes: [
        %PropertyComponent{
          data: %{
            occurences: 1,
            id: "id",
            ecu_id: "ecu_id",
            status: "status"
          }
        }
      ],
      mileage_meters: %PropertyComponent{data: 11}
    }

    new_state =
      state
      |> DiagnosticsState.to_bin()
      |> DiagnosticsState.from_bin()

    assert new_state == state
  end
end
