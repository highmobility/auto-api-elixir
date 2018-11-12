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
defmodule AutoApi.WindowsCapability do
  @moduledoc """
  Basic settings for Windows Capability

      iex> alias AutoApi.WindowsCapability, as: W
      iex> W.identifier
      <<0x00, 0x45>>
      iex> W.name
      :windows
      iex> W.description
      "Windows"
      iex> W.command_name(0x00)
      :get_windows_state
      iex> W.command_name(0x01)
      :windows_state
      iex> W.command_name(0x12)
      :control_windows
      iex> length(W.properties)
      2
      iex> W.properties
      [{2, :windows_open_percentages}, {3, :windows_positions}]
  """

  @spec_file "specs/windows.json"
  @type command_type :: :get_windows_state | :windows_state | :control_windows

  @command_module AutoApi.NotImplemented
  @state_module AutoApi.WindowsState

  use AutoApi.Capability
end
