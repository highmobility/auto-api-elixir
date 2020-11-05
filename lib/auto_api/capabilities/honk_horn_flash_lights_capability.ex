defmodule AutoApiL11.HonkHornFlashLightsCapability do
  @moduledoc """
  Basic settings for HonkHornFlashLights Capability

      iex> alias AutoApiL11.HonkHornFlashLightsCapability, as: H
      iex> H.identifier
      <<0x00, 0x26>>
      iex> H.name
      :honk_horn_flash_lights
      iex> H.description
      "Honk Horn & Flash Lights"
      iex> length(H.properties)
      4
      iex> List.last(H.properties)
      {0x04, :emergency_flashers_state}
  """

  @command_module AutoApiL11.HonkHornFlashLightsCommand
  @state_module AutoApiL11.HonkHornFlashLightsState

  use AutoApiL11.Capability, spec_file: "specs/honk_horn_flash_lights.json"
end
