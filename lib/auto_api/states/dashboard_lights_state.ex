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

defmodule AutoApi.DashboardLightsState do
  @moduledoc """
  Keeps Dashboard Lights state
  """

  alias AutoApi.State

  use AutoApi.State, spec_file: "dashboard_lights.json"

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

  @type state :: :inactive | :info | :yellow | :red
  @type dashboard_lights :: %PropertyComponent{data: %{name: light_name, state: state}}
  @type t :: %__MODULE__{
          dashboard_lights: State.multiple_property(dashboard_light())
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 5, 1, 0, 2, 1, 1>>
    iex> AutoApi.DashboardLightsState.from_bin(bin)
    %AutoApi.DashboardLightsState{dashboard_lights: [%AutoApi.PropertyComponent{data: %{name: :low_beam, state: :info}}]}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> state = %AutoApi.DashboardLightsState{dashboard_lights: [%AutoApi.PropertyComponent{data: %{name: :low_beam, state: :info}}]}
    iex> AutoApi.DashboardLightsState.to_bin(state)
    <<1, 0, 5, 1, 0, 2, 1, 1>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
