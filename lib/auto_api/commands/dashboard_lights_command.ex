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
  use AutoApi.Command

  alias AutoApi.DashboardLightsState

  @doc """
  Converts DashboardLightsCommand state to capability's state in binary

  """
  @spec state(DashboardLightsState.t()) :: binary
  def state(%DashboardLightsState{} = state) do
    <<0x01, DashboardLightsState.to_bin(state)::binary>>
  end
end
