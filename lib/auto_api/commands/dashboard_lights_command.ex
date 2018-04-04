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
defmodule AutoApi.DashboardLightsCommand do
  @moduledoc """
  Handles Dashboard Lights commands and apply binary commands on `%AutoApi.DashboardLightsState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.DashboardLightsState
  alias AutoApi.DashboardLightsCapability

  @doc """
  Parses the binary command and makes changes or returns the state

        iex> AutoApi.DashboardLightsCommand.execute(%AutoApi.DashboardLightsState{}, <<0x00>>)
        {:state, %AutoApi.DashboardLightsState{}}

        iex> command = <<0x01>> <> <<0x01, 2::integer-16, 0x02, 0x03>>
        iex> AutoApi.DashboardLightsCommand.execute(%AutoApi.DashboardLightsState{}, command)
        {:state_changed, %AutoApi.DashboardLightsState{dashboard_light: [%{light_name: :hazard_warning, state: :red}]}}

  """
  @spec execute(DashboardLightsState.t(), binary) ::
          {:state | :state_changed, DashboardLightsState.t()}
  def execute(%DashboardLightsState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%DashboardLightsState{} = state, <<0x01, ds::binary>>) do
    new_state = DashboardLightsState.from_bin(ds)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts DashboardLightsCommand state to capability's state in binary

        iex> properties = AutoApi.DashboardLightsCapability.properties |> Enum.into(%{}) |> Map.values()
        iex> AutoApi.DashboardLightsCommand.state(%AutoApi.DashboardLightsState{dashboard_light: [%{light_name: :engine_oil, state: :info}], properties: properties})
        <<0x01, 0x01, 2::integer-16, 0x08, 0x01>>
  """
  @spec state(DashboardLightsState.t()) :: binary
  def state(%DashboardLightsState{} = state) do
    <<0x01, DashboardLightsState.to_bin(state)::binary>>
  end

  @doc """
  Converts command to binary format

        iex> AutoApi.DashboardLightsCommand.to_bin(:get_dashboard_lights, [])
        <<0x00>>
  """
  @spec to_bin(DiagnosticsCapability.command_type(), list(any())) :: binary
  def to_bin(:get_dashboard_lights, []) do
    cmd_id = DashboardLightsCapability.command_id(:get_dashboard_lights)
    <<cmd_id>>
  end
end
