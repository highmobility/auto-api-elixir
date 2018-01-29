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
defmodule AutoApi.TextInputCapability do
  @moduledoc """
  Basic settings for TextInput Capability

      iex> alias AutoApi.TextInputCapability, as: T
      iex> T.identifier
      <<0x00, 0x44>>
      iex> T.name
      :text_input
      iex> T.description
      "Text Input"
      iex> T.command_name(0x00)
      :text_input
      iex> length(T.properties)
      0
  """

  @spec_file "specs/text_input.json"
  @type command_type :: :text_input

  @command_module AutoApi.NotImplemented
  @state_module AutoApi.NotImplemented

  use AutoApi.Capability
end
