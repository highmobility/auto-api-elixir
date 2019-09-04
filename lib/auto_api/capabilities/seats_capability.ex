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
defmodule AutoApi.SeatsCapability do
  @moduledoc """
  Basic settings for Seats Capability

      iex> alias AutoApi.SeatsCapability, as: S
      iex> S.identifier
      <<0x00, 0x56>>
      iex> S.name
      :seats
      iex> S.description
      "Seats"
      iex> length(S.properties)
      2
      iex> List.last(S.properties)
      {0x03, :seatbelts_state}
  """

  @type command_type :: :get_seats_state | :seats_state

  @command_module AutoApi.NotImplemented
  @state_module AutoApi.SeatsState

  use AutoApi.Capability, spec_file: "specs/seats.json"
end
