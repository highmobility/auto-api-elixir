defmodule AutoApi.HonkHornFlashLightsCapability do
  @moduledoc """
  Basic settings for HonkHornFlashLights Capability

      iex> alias AutoApi.HonkHornFlashLightsCapability, as: H
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

  @command_module AutoApi.HonkHornFlashLightsCommand
  @state_module AutoApi.HonkHornFlashLightsState

  use AutoApi.Capability, spec_file: "honk_horn_flash_lights.json"
end
