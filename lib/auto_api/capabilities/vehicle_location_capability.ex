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
defmodule AutoApi.VehicleLocationCapability do
  @moduledoc """
  Basic settings for Vehicle Location Capability

      iex> alias AutoApi.VehicleLocationCapability, as: VL
      iex> VL.identifier
      <<0x00, 0x30>>
      iex> VL.name
      :vehicle_location
      iex> VL.description
      "Vehicle Location"
      iex> length(VL.properties)
      3
      iex> VL.properties
      [{4, :coordinates}, {5, :heading}, {6, :altitude}]
  """

  @type command_type :: :vehicle_location | :get_vehicle_location

  @command_module AutoApi.VehicleLocationCommand
  @state_module AutoApi.VehicleLocationState

  use AutoApi.Capability, spec_file: "specs/vehicle_location.json"
end
