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
defmodule AutoApi.NaviDestinationCapability do
  @moduledoc """
  Basic settings for Navi Destination Capability

      iex> alias AutoApi.NaviDestinationCapability, as: N
      iex> N.identifier
      <<0x00, 0x31>>
      iex> N.name
      :navi_destination
      iex> N.description
      "Navi Destination"
      iex> N.command_name(0x00)
      :get_navi_destination
      iex> N.command_name(0x01)
      :navi_destination
      iex> N.command_name(0x02)
      :set_navi_destination
      iex> length(N.properties)
      2
      iex> List.last(N.properties)
      {0x02, :destination_name}
  """

  @spec_file "specs/navi_destination.json"
  @type command_type :: :get_navi_destination | :navi_destination | :set_navi_destination

  @command_module AutoApi.NotImplemented
  @state_module AutoApi.NotImplemented

  use AutoApi.Capability
end