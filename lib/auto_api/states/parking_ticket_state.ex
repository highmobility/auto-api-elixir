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
defmodule AutoApi.ParkingTicketState do
  @moduledoc """
  ParkingTicket state
  """

  alias AutoApi.{CommonData, PropertyComponent}

  defstruct status: nil,
            operator_name: nil,
            operator_ticket_id: nil,
            ticket_start_time: nil,
            ticket_end_time: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "specs/parking_ticket.json"

  @type parking_ticket_state :: :ended | :started

  @type t :: %__MODULE__{
          status: %PropertyComponent{data: parking_ticket_state} | nil,
          operator_name: %PropertyComponent{data: String.t()} | nil,
          operator_ticket_id: %PropertyComponent{data: String.t()} | nil,
          ticket_start_time: %PropertyComponent{data: DateTime.t()} | nil,
          ticket_end_time: %PropertyComponent{data: DateTime.t()} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 4, 1, 0, 1, 1>>
    iex> AutoApi.ParkingTicketState.from_bin(bin)
    %AutoApi.ParkingTicketState{status: %AutoApi.PropertyComponent{data: :started}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.ParkingTicketState{status: %AutoApi.PropertyComponent{data: :started}}
    iex> AutoApi.ParkingTicketState.to_bin(state)
    <<1, 0, 4, 1, 0, 1, 1>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
