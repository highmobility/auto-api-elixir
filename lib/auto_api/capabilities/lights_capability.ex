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
defmodule AutoApi.LightsCapability do
  @moduledoc """
  Basic settings for Lights Capability

      iex> alias AutoApi.LightsCapability, as: L
      iex> L.identifier
      <<0x00, 0x36>>
      iex> L.name
      :lights
      iex> L.description
      "Lights"
      iex> length(L.properties)
      8
      iex> List.last(L.properties)
      {9, :interior_lights}
  """

  @spec_file "specs/lights.json"
  @type command_type :: :get_lights_state | :lights_state | :control_lights

  @command_module AutoApi.NotImplemented
  @state_module AutoApi.LightsState

  use AutoApi.Capability
end
