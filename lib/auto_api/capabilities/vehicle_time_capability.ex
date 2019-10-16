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
      iex> length(VT.properties)
      1
  """

  @command_module AutoApi.VehicleTimeCommand
  @state_module AutoApi.VehicleTimeState

  use AutoApi.Capability, spec_file: "specs/vehicle_time.json"
end
