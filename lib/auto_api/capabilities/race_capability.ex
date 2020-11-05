defmodule AutoApiL11.RaceCapability do
  @moduledoc """
  Basic settings for Race Capability

      iex> alias AutoApiL11.RaceCapability, as: R
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

  @command_module AutoApiL11.RaceCommand
  @state_module AutoApiL11.RaceState

  use AutoApiL11.Capability, spec_file: "specs/race.json"
end
