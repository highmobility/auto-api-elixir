defmodule AutoApiL11.SeatsCapability do
  @moduledoc """
  Basic settings for Seats Capability

      iex> alias AutoApiL11.SeatsCapability, as: S
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

  @command_module AutoApiL11.SeatsCommand
  @state_module AutoApiL11.SeatsState

  use AutoApiL11.Capability, spec_file: "specs/seats.json"
end
