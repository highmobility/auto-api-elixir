defmodule AutoApi.RaceCapability do
  @moduledoc """
  Basic settings for Race Capability

      iex> alias AutoApi.RaceCapability, as: R
      iex> R.identifier
      <<0x00, 0x57>>
      iex> R.name
      :race
      iex> R.description
      "Race"
      iex> length(R.properties)
      18
      iex> List.last(R.properties)
      {18, :vehicle_moving}
  """

  @command_module AutoApi.RaceCommand
  @state_module AutoApi.RaceState

  use AutoApi.Capability, spec_file: "race.json"
end
