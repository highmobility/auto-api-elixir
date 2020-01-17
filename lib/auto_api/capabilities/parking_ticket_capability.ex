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
      iex> length(P.properties)
      5
      iex> List.last(P.properties)
      {5, :ticket_end_time}
  """

  @command_module AutoApi.ParkingTicketCommand
  @state_module AutoApi.ParkingTicketState

  use AutoApi.Capability, spec_file: "specs/parking_ticket.json"
end
