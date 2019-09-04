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
defmodule AutoApi.FirmwareVersionCapability do
  @moduledoc """
  Basic settings for Browser Capability

      iex> alias AutoApi.FirmwareVersionCapability, as: F
      iex> F.identifier
      <<0x00, 0x03>>
      iex> F.name
      :firmware_version
      iex> F.description
      "Firmware Version"
      iex> length(F.properties)
      3
  """

  @type command_type :: :get_firmware_version | :firmware_version

  @command_module AutoApi.NotImplemented
  @state_module AutoApi.FirmwareVersionState

  use AutoApi.Capability, spec_file: "specs/firmware_version.json"
end
