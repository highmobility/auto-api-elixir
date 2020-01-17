defmodule AutoApi.LightsCapability do
  @moduledoc """
  Basic settings for Lights Capability

      iex> alias AutoApi.LightsCapability, as: L
      iex> L.identifier
      <<0x00, 0x36>>
      iex> L.name
      :lights
      iex> L.description
      "Lights"
      iex> length(L.properties)
      8
      iex> List.last(L.properties)
      {9, :interior_lights}
  """

  @command_module AutoApi.LightsCommand
  @state_module AutoApi.LightsState

  use AutoApi.Capability, spec_file: "specs/lights.json"
end
