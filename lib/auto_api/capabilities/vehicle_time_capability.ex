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
defmodule AutoApi.VehicleTimeCapability do
  @moduledoc """
  Basic settings for Vehicle Time Capability

      iex> alias AutoApi.VehicleTimeCapability, as: VT
      iex> VT.identifier
      <<0x00, 0x50>>
      iex> VT.name
      :vehicle_time
      iex> VT.description
      "Vehicle Time"
      iex> VT.command_name(0x00)
      :get_vehicle_time
      iex> VT.command_name(0x01)
      :vehicle_time
      iex> length(VT.properties)
      1
  """

  @spec_file "specs/vehicle_time.json"
  @type command_type :: :vehicle_time | :get_vehicle_time

  @command_module AutoApi.NotImplemented
  @state_module AutoApi.NotImplemented

  use AutoApi.Capability
end
