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
defmodule AutoApi.TrunkCapability do
  @moduledoc """
  Basic settings for Trunk Capability

      iex> alias AutoApi.TrunkCapability, as: T
      iex> T.identifier
      <<0x00, 0x21>>
      iex> T.name
      :trunk
      iex> T.description
      "Trunk"
      iex> T.command_name(0x00)
      :get_trunk_state
      iex> T.command_name(0x01)
      :trunk_state
      iex> T.command_name(0x12)
      :control_trunk
      iex> length(T.properties)
      2
      iex> T.properties
      [{1, :trunk_lock}, {2, :trunk_position}]
  """

  @spec_file "specs/trunk.json"
  @type command_type :: :get_trunk_state | :trunk_state | :open_close_trunk

  @command_module AutoApi.NotImplemented
  @state_module AutoApi.TrunkState

  use AutoApi.Capability
end
