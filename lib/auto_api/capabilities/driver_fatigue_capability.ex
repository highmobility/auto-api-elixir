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
defmodule AutoApi.DriverFatigueCapability do
  @moduledoc """
  Basic settings for Driver Fatigue Capability

      iex> alias AutoApi.DriverFatigueCapability, as: D
      iex> D.identifier
      <<0x00, 0x41>>
      iex> D.name
      :driver_fatigue
      iex> D.description
      "Driver Fatigue"
      iex> D.command_name(0x01)
      :driver_fatigue_detected
      iex> length(D.properties)
      0
  """

  @spec_file "specs/driver_fatigue.json"
  @type command_type :: :driver_fatigue_detected

  @command_module AutoApi.NotImplemented
  @state_module AutoApi.NotImplemented

  use AutoApi.Capability
end
