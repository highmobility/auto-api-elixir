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

defmodule AutoApiL12.DashboardLightsState do
  @moduledoc """
  Keeps Dashboard Lights state
  """

  alias AutoApiL12.{CommonData, State}

  use AutoApiL12.State, spec_file: "dashboard_lights.json"

  @type light_name ::
          :high_beam
          | :low_beam
          | :hazard_warning
          | :brake_failure
          | :hatch_open
          | :fuel_level
          | :engine_coolant_temperature
          | :battery_charging_condition
          | :engine_oil
          | :position_lights
          | :front_fog_light
          | :rear_fog_light
          | :park_heating
          | :engine_indicator
          | :service_call
          | :transmission_fluid_temperature
          | :transmission_failure
          | :anti_lock_brake_failure
          | :worn_brake_linings
          | :windscreen_washer_fluid
          | :tire_failure
          | :engine_oil_level
          | :engine_coolant_level
          | :steering_failure
          | :esc_indication
          | :brake_lights
          | :adblue_level
          | :fuel_filter_diff_pressure
          | :seat_belt
          | :advanced_braking
          | :acc
          | :trailer_connected
          | :airbag
          | :esc_switched_off
          | :lane_departure_warning_off
          | :air_filter_minder
          | :air_suspension_ride_control_fault
          | :all_wheel_drive_disabled
          | :anti_theft
          | :blind_spot_detection
          | :charge_system_fault
          | :check_fuel_cap
          | :check_fuel_fill_inlet
          | :check_fuel_filter
          | :dc_temp_warning
          | :dc_warning_status
          | :diesel_engine_idle_shutdown
          | :diesel_engine_warning
          | :diesel_exhaust_fluid_system_fault
          | :diesel_exhaust_over_temp
          | :diesel_exhaust_fluid_quality
          | :diesel_filter_regeneration
          | :diesel_particulate_filter
          | :diesel_pre_heat
          | :electric_trailer_brake_connection
          | :ev_battery_cell_max_volt_warning
          | :ev_battery_cell_min_volt_warning
          | :ev_battery_charge_energy_storage_warning
          | :ev_battery_high_level_warning
          | :ev_battery_high_temperature_warning
          | :ev_battery_insulation_resist_warning
          | :ev_battery_jump_level_warning
          | :ev_battery_low_level_warning
          | :ev_battery_max_volt_veh_energy_warning
          | :ev_battery_min_volt_veh_energy_warning
          | :ev_battery_over_charge_warning
          | :ev_battery_poor_cell_warning
          | :ev_battery_temp_diff_warning
          | :forward_collision_warning
          | :fuel_door_open
          | :hill_descent_control_fault
          | :hill_start_assist_warning
          | :hv_interlocking_status_warning
          | :lighting_system_failure
          | :malfunction_indicator
          | :motor_controller_temp_warning
          | :park_aid_malfunction
          | :passive_entry_passive_start
          | :powertrain_malfunction
          | :restraints_indicator_warning
          | :start_stop_engine_warning
          | :traction_control_disabled
          | :traction_control_active
          | :traction_motor_temp_warning
          | :tire_pressure_monitor_system_warning
          | :water_in_fuel
          | :tire_warning_front_right
          | :tire_warning_front_left
          | :tire_warning_rear_right
          | :tire_warning_rear_left
          | :tire_warning_system_error
          | :battery_low_warning
          | :brake_fluid_warning

  @type dashboard_light :: %{name: light_name, state: CommonData.on_off()}
  @type t :: %__MODULE__{
          dashboard_lights: State.multiple_property(dashboard_light())
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 5, 1, 0, 2, 1, 1>>
    iex> AutoApiL12.DashboardLightsState.from_bin(bin)
    %AutoApiL12.DashboardLightsState{dashboard_lights: [%AutoApiL12.Property{data: %{name: :low_beam, state: :on}}]}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> state = %AutoApiL12.DashboardLightsState{dashboard_lights: [%AutoApiL12.Property{data: %{name: :low_beam, state: :off}}]}
    iex> AutoApiL12.DashboardLightsState.to_bin(state)
    <<1, 0, 5, 1, 0, 2, 1, 0>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
