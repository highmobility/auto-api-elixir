defmodule AutoApi.TripsCapability do
  @moduledoc """
  Basic settings for Trips Capability

      iex> alias AutoApi.TripsCapability, as: T
      iex> T.identifier
      <<0x00, 0x6A>>
      iex> T.name
      :trips
      iex> T.description
      "Trips"
      iex> length(T.properties)
      15
      iex> List.first(T.properties)
      {1, :type}
  """

  @command_module AutoApi.TripsCommand
  @state_module AutoApi.TripsState

  use AutoApi.Capability, spec_file: "trips.json"
end
