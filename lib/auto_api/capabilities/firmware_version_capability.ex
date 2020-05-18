defmodule AutoApi.FirmwareVersionCapability do
  @moduledoc """
  Basic settings for Browser Capability

      iex> alias AutoApi.FirmwareVersionCapability, as: F
      iex> F.identifier
      <<0x00, 0x03>>
      iex> F.name
      :firmware_version
      iex> F.description
      "Firmware Version"
      iex> length(F.properties)
      3
  """

  @command_module AutoApi.FirmwareVersionCommand
  @state_module AutoApi.FirmwareVersionState

  use AutoApi.Capability, spec_file: "firmware_version.json"
end
