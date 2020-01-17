defmodule AutoApi.NaviDestinationCapability do
  @moduledoc """
  Basic settings for Navi Destination Capability

      iex> alias AutoApi.NaviDestinationCapability, as: N
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

  @command_module AutoApi.NaviDestinationCommand
  @state_module AutoApi.NaviDestinationState

  use AutoApi.Capability, spec_file: "specs/navi_destination.json"
end
