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
defmodule AutoApi.BrowserCapability do
  @moduledoc """
  Basic settings for Browser Capability

      iex> alias AutoApi.BrowserCapability, as: B
      iex> B.identifier
      <<0x00, 0x49>>
      iex> B.name
      :browser
      iex> B.description
      "Browser"
      iex> B.command_name(0x00)
      :load_url
      iex> length(B.properties)
      0
  """

  @spec_file "specs/browser.json"
  @type command_type :: :browser

  @command_module AutoApi.NotImplemented
  @state_module AutoApi.NotImplemented

  use AutoApi.Capability
end
