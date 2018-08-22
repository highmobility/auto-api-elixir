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
defmodule AutoApi.DashboardLightsState do
  @moduledoc """
  Keeps Charging state
  """

  @doc """
  Dashboard Lights state
  """
  defstruct dashboard_light: [],
            timestamp: nil,
            properties: []

  use AutoApi.State, spec_file: "specs/dashboard_lights.json"

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
  @type dashboard_light :: %{light_name: light_name, state: state}
  @type t :: %__MODULE__{
          dashboard_light: list(dashboard_light),
          timestamp: DateTime.t() | nil,
          properties: list(atom)
        }

  @doc """
  Build state based on binary value

    iex> AutoApi.DashboardLightsState.from_bin(<<0x01, 2::integer-16, 0x00, 0x00>>)
    %AutoApi.DashboardLightsState{dashboard_light: [%{light_name: :high_beam, state: :inactive}]}


    iex> AutoApi.DashboardLightsState.from_bin(<<0x01, 2::integer-16, 0x0A, 0x03, 0x01, 2::integer-16, 0x1F, 0x02>>)
    %AutoApi.DashboardLightsState{dashboard_light: [%{light_name: :trailer_connected, state: :yellow}, %{light_name: :front_fog_light, state: :red}]}

  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> properties = [:dashboard_light]
    iex> AutoApi.DashboardLightsState.to_bin(%AutoApi.DashboardLightsState{dashboard_light: [%{light_name: :fuel_level, state: :info}, %{light_name: :lane_departure_warning_off, state: :inactive}], properties: properties})
    <<0x01, 2::integer-16, 0x05, 0x01, 0x01, 2::integer-16, 0x22, 0x00>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
