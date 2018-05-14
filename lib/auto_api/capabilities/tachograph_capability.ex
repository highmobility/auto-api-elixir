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
defmodule AutoApi.TachographCapability do
  @moduledoc """
  Basic settings for Tachograph Capability

      iex> alias AutoApi.TachographCapability, as: T
      iex> T.identifier
      <<0x00, 0x64>>
      iex> T.name
      :tachograph
      iex> T.description
      "Tachograph"
      iex> T.command_name(0x00)
      :get_tachograph_state
      iex> T.command_name(0x01)
      :tachograph_state
      iex> length(T.properties)
      7
      iex> List.last(T.properties)
      {7, :vehicle_speed}
  """

  @spec_file "specs/tachograph.json"
  @type command_type :: :get_tachograph_state | :tachograph_state

  @command_module AutoApi.TachographCommand
  @state_module AutoApi.TachographState

  use AutoApi.Capability
end