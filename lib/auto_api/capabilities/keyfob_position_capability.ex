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
defmodule AutoApi.KeyfobPositionCapability do
  @moduledoc """
  Basic settings for KeyfobPosition Capability

      iex> alias AutoApi.KeyfobPositionCapability, as: K
      iex> K.identifier
      <<0x00, 0x48>>
      iex> K.name
      :keyfob_position
      iex> K.description
      "Keyfob Position"
      iex> K.command_name(0x00)
      :get_keyfob_position
      iex> K.command_name(0x01)
      :keyfob_position
      iex> length(K.properties)
      1
      iex> List.last(K.properties)
      {0x01, :keyfob_position}
  """

  @spec_file "specs/keyfob_position.json"
  @type command_type :: :get_keyfob_position | :keyfob_position

  @command_module AutoApi.NotImplemented
  @state_module AutoApi.KeyfobPositionState

  use AutoApi.Capability
end
