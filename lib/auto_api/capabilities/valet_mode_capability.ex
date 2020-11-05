defmodule AutoApiL11.ValetModeCapability do
  @moduledoc """
  Basic settings for ValetMode Capability

      iex> alias AutoApiL11.ValetModeCapability, as: V
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

  @command_module AutoApiL11.ValetModeCommand
  @state_module AutoApiL11.ValetModeState

  use AutoApiL11.Capability, spec_file: "specs/valet_mode.json"
end
