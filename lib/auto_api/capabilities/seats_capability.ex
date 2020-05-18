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

  @command_module AutoApi.SeatsCommand
  @state_module AutoApi.SeatsState

  use AutoApi.Capability, spec_file: "seats.json"
end
