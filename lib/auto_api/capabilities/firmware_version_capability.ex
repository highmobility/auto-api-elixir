defmodule AutoApiL11.FirmwareVersionCapability do
  @moduledoc """
  Basic settings for Browser Capability

      iex> alias AutoApiL11.FirmwareVersionCapability, as: F
      iex> F.identifier
      <<0x00, 0x03>>
      iex> F.name
      :firmware_version
      iex> F.description
      "Firmware Version"
      iex> length(F.properties)
      3
  """

  @command_module AutoApiL11.FirmwareVersionCommand
  @state_module AutoApiL11.FirmwareVersionState

  use AutoApiL11.Capability, spec_file: "specs/firmware_version.json"
end
