defmodule AutoApi.HomeChargerCapability do
  @moduledoc """
  Basic settings for HomeCharger Capability

      iex> alias AutoApi.HomeChargerCapability, as: H
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

  @command_module AutoApi.HomeChargerCommand
  @state_module AutoApi.HomeChargerState

  use AutoApi.Capability, spec_file: "home_charger.json"
end
