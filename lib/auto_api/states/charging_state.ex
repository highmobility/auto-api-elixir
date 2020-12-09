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
defmodule AutoApi.ChargingState do
  @moduledoc """
  Keeps Charging state
  """

  alias AutoApi.{CommonData, State, UnitType}

  use AutoApi.State, spec_file: "charging.json"

  @type charge_mode :: :immediate | :timer_based | :inductive
  @type charging :: :disconnected | :plugged_in | :charging | :charging_complete
  @type charging_state ::
          :not_charging
          | :charging
          | :charging_complete
          | :initialising
          | :charging_paused
          | :charging_error
          | :cable_unplugged
          | :slow_charging
          | :fast_charging
          | :discharging
          | :foreign_object_detected
  @type charging_window_chosen :: :not_chosen | :chosen
  @type current_type :: :alternating_current | :direct_current
  @type departure_time ::
          %{state: :inactive | :active, time: %{hour: integer, minute: integer}}
  @type plug_type :: :type_1 | :type_2 | :ccs | :chademo
  @type plugged_in :: :disconnected | :plugged_in
  @type preconditioning_error ::
          :no_change
          | :not_possible_low
          | :not_possible_finished
          | :available_after_engine_restart
          | :general_error
  @type reduction_time ::
          %{start_stop: :start | :stop, time: %{hour: integer, minute: integer}}
  @type smart_charging_status :: :wallbox_is_active | :scc_is_active | :peak_setting_active
  @type starter_battery_state :: :red | :yellow | :green
  @type timer_type :: :preferred_start_time | :preferred_end_time | :departure_date
  @type timer ::
          %{
            timer_type: timer_type,
            date: DateTime.t()
          }

  @type t :: %__MODULE__{
          estimated_range: State.property(UnitType.length()),
          battery_level: State.property(float()),
          # Deprecated
          battery_current_ac: State.property(UnitType.electric_current()),
          # Deprecated
          battery_current_dc: State.property(UnitType.electric_current()),
          # Deprecated
          charger_voltage_ac: State.property(UnitType.electric_potential_difference()),
          # Deprecated
          charger_voltage_dc: State.property(UnitType.electric_potential_difference()),
          charge_limit: State.property(float()),
          time_to_complete_charge: State.property(UnitType.duration()),
          # Deprecated
          charging_rate_kw: State.property(UnitType.power()),
          charge_port_state: State.property(CommonData.position()),
          charge_mode: State.property(charge_mode()),
          max_charging_current: State.property(UnitType.electric_current()),
          plug_type: State.property(plug_type()),
          charging_window_chosen: State.property(charging_window_chosen()),
          departure_times: State.multiple_property(departure_time()),
          reduction_times: State.multiple_property(reduction_time()),
          battery_temperature: State.property(UnitType.temperature()),
          timers: State.multiple_property(timer),
          plugged_in: State.property(plugged_in()),
          status: State.property(charging_state),
          charging_rate: State.property(UnitType.power()),
          battery_current: State.property(UnitType.electric_current()),
          charger_voltage: State.property(UnitType.electric_potential_difference()),
          current_type: State.property(current_type()),
          max_range: State.property(UnitType.length()),
          starter_battery_state: State.property(starter_battery_state()),
          smart_charging_status: State.property(smart_charging_status()),
          battery_level_at_departure: State.property(float()),
          preconditioning_departure_status: State.property(CommonData.activity()),
          preconditioning_immediate_status: State.property(CommonData.activity()),
          preconditioning_departure_enabled: State.property(CommonData.enabled_state()),
          preconditioning_error: State.property(preconditioning_error())
        }

  @doc """
  Build state based on binary value

    iex> bin = <<23, 0, 4, 1, 0, 1, 8>>
    iex> AutoApi.ChargingState.from_bin(bin)
    %AutoApi.ChargingState{status: %AutoApi.PropertyComponent{data: :fast_charging}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> state = %AutoApi.ChargingState{status: %AutoApi.PropertyComponent{data: :fast_charging}}
    iex> AutoApi.ChargingState.to_bin(state)
    <<23, 0, 4, 1, 0, 1, 8>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
