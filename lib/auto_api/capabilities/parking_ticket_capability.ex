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
defmodule AutoApi.ParkingTicketCapability do
  @moduledoc """
  Basic settings for ParkingTicket Capability

      iex> alias AutoApi.ParkingTicketCapability, as: P
      iex> P.identifier
      <<0x00, 0x47>>
      iex> P.name
      :parking_ticket
      iex> P.description
      "Parking Ticket"
      iex> P.command_name(0x00)
      :get_parking_ticket
      iex> P.command_name(0x01)
      :parking_ticket
      iex> P.command_name(0x02)
      :start_parking
      iex> P.command_name(0x03)
      :end_parking
      iex> length(P.properties)
      5
      iex> List.last(P.properties)
      {5, :ticket_end_time}
  """

  @spec_file "specs/parking_ticket.json"
  @type command_type :: :get_parking_ticket | :parking_ticket | :start_parking | :end_parking

  @command_module AutoApi.NotImplemented
  @state_module AutoApi.NotImplemented

  use AutoApi.Capability
end
