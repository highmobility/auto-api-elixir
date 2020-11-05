defmodule AutoApiL11.NaviDestinationCapability do
  @moduledoc """
  Basic settings for Navi Destination Capability

      iex> alias AutoApiL11.NaviDestinationCapability, as: N
      iex> N.identifier
      <<0x00, 0x31>>
      iex> N.name
      :navi_destination
      iex> N.description
      "Navi Destination"
      iex> length(N.properties)
      6
      iex> List.last(N.properties)
      {0x06, :distance_to_destination}
  """

  @command_module AutoApiL11.NaviDestinationCommand
  @state_module AutoApiL11.NaviDestinationState

  use AutoApiL11.Capability, spec_file: "specs/navi_destination.json"
end
