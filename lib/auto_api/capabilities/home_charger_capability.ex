defmodule AutoApiL11.HomeChargerCapability do
  @moduledoc """
  Basic settings for HomeCharger Capability

      iex> alias AutoApiL11.HomeChargerCapability, as: H
      iex> H.identifier
      <<0x00, 0x60>>
      iex> H.name
      :home_charger
      iex> H.description
      "Home Charger"
      iex> length(H.properties)
      15
      iex> List.last(H.properties)
      {0x12, :price_tariffs}
  """

  @command_module AutoApiL11.HomeChargerCommand
  @state_module AutoApiL11.HomeChargerState

  use AutoApiL11.Capability, spec_file: "specs/home_charger.json"
end
