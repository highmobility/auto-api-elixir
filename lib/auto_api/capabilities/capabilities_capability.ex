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
defmodule AutoApi.CapabilitiesCapability do
  @moduledoc """
  Basic settings for Capabilities "Capability".

      iex> alias AutoApi.CapabilitiesCapability, as: C
      iex> C.identifier
      <<0x00, 0x10>>
      iex> C.name
      :capabilities
      iex> C.description
      "Capabilities"
      iex> C.command_name(0x00)
      :get_capabilities
      iex> C.command_name(0x02)
      :get_capability
      iex> C.command_name(0x01)
      :capabilities
      iex> List.last(C.properties)
      {0x01, :capability}
  """

  @spec_file "specs/capabilities.json"
  @type command_type :: :get_capabilities | :get_capability | :capabilities

  @command_module AutoApi.CapabilitiesCommand
  @state_module AutoApi.CapabilitiesState

  use AutoApi.Capability
end
