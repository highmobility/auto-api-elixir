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
defmodule AutoApi.ParkingBrakeCapability do
  @moduledoc """
  Basic settings for ParkingBrake Capability

      iex> alias AutoApi.ParkingBrakeCapability, as: P
      iex> P.identifier
      <<0x00, 0x58>>
      iex> P.name
      :parking_brake
      iex> P.description
      "Parking Brake"
      iex> P.command_name(0x00)
      :get_parking_brake_state
      iex> P.command_name(0x01)
      :parking_brake_state
      iex> P.command_name(0x02)
      :set_parking_brake
      iex> length(P.properties)
      1
      iex> P.properties
      [{1, :parking_brake}]
  """

  @spec_file "specs/parking_brake.json"
  @type command_type :: :get_parking_brake_state | :parking_brake_state | :set_parking_brake

  @command_module AutoApi.NotImplemented
  @state_module AutoApi.NotImplemented

  use AutoApi.Capability
end
