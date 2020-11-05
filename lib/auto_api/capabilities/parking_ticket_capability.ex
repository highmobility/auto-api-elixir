defmodule AutoApiL11.ParkingTicketCapability do
  @moduledoc """
  Basic settings for ParkingTicket Capability

      iex> alias AutoApiL11.ParkingTicketCapability, as: P
      iex> P.identifier
      <<0x00, 0x47>>
      iex> P.name
      :parking_ticket
      iex> P.description
      "Parking Ticket"
      iex> length(P.properties)
      5
      iex> List.last(P.properties)
      {5, :ticket_end_time}
  """

  @command_module AutoApiL11.ParkingTicketCommand
  @state_module AutoApiL11.ParkingTicketState

  use AutoApiL11.Capability, spec_file: "specs/parking_ticket.json"
end
