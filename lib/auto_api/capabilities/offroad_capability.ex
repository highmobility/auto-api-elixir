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
defmodule AutoApi.OffroadCapability do
  @moduledoc """
  Basic settings for Offroad Capability

      iex> alias AutoApi.OffroadCapability, as: O
      iex> O.identifier
      <<0x00, 0x52>>
      iex> O.name
      :offroad
      iex> O.description
      "Offroad"
      iex> O.command_name(0x00)
      :get_offroad_state
      iex> O.command_name(0x01)
      :offroad_state
      iex> length(O.properties)
      2
      iex> List.last(O.properties)
      {0x02, :wheel_suspension}
  """

  @spec_file "specs/offroad.json"
  @type command_type :: :get_offroad_state | :offroad_state

  @command_module AutoApi.NotImplemented
  @state_module AutoApi.NotImplemented

  use AutoApi.Capability
end
