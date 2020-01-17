defmodule AutoApi.ValetModeCapability do
  @moduledoc """
  Basic settings for ValetMode Capability

      iex> alias AutoApi.ValetModeCapability, as: V
      iex> V.identifier
      <<0x00, 0x28>>
      iex> V.name
      :valet_mode
      iex> V.description
      "Valet Mode"
      iex> length(V.properties)
      1
      iex> List.last(V.properties)
      {0x01, :status}
  """

  @command_module AutoApi.ValetModeCommand
  @state_module AutoApi.ValetModeState

  use AutoApi.Capability, spec_file: "specs/valet_mode.json"
end
