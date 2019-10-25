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
defmodule AutoApi.LightConditionsCapability do
  @moduledoc """
  Basic settings for Light Conditions Capability

      iex> alias AutoApi.LightConditionsCapability, as: L
      iex> L.identifier
      <<0x00, 0x54>>
      iex> L.name
      :light_conditions
      iex> L.description
      "Light Conditions"
      iex> L.command_name(0x00)
      :get_light_conditions
      iex> L.command_name(0x01)
      :light_conditions
      iex> length(L.properties)
      2
      iex> List.last(L.properties)
      {0x02, :inside_light}
  """

  @spec_file "specs/light_conditions.json"
  @type command_type :: :get_light_conditions | :light_conditions

  @command_module AutoApi.NotImplemented
  @state_module AutoApi.LightConditionsState

  use AutoApi.Capability
end
