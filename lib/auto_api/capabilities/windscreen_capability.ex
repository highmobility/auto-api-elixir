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
defmodule AutoApi.WindscreenCapability do
  @moduledoc """
  Basic settings for Diagnostics Capability

      iex> alias AutoApi.WindscreenCapability, as: W
      iex> W.identifier
      <<0x00, 0x42>>
      iex> W.name
      :windscreen
      iex> W.description
      "Windscreen"
      iex> W.command_name(0x00)
      :get_windscreen_state
      iex> W.command_name(0x01)
      :windscreen_state
      iex> W.command_name(0x02)
      :set_windscreen_damage
      iex> length(W.properties)
      8
      iex> List.last(W.properties)
      {0x08, :windscreen_damage_detection_time}
  """

  @spec_file "specs/windscreen.json"
  @type command_type :: :get_windscreen_state | :windscreen_state | :set_windscreen_damage

  @command_module AutoApi.NotImplemented
  @state_module AutoApi.NotImplemented

  use AutoApi.Capability
end
