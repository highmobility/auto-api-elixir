defmodule AutoApiL11.DiagnosticsCapability do
  @moduledoc """
  Basic settings for Diagnostics Capability

      iex> alias AutoApiL11.DiagnosticsCapability, as: D
      iex> D.identifier
      <<0x00, 0x33>>
      iex> D.name
      :diagnostics
      iex> D.description
      "Diagnostics"
      iex> length(D.properties)
      27
  """

  @command_module AutoApiL11.DiagnosticsCommand
  @state_module AutoApiL11.DiagnosticsState

  use AutoApiL11.Capability, spec_file: "specs/diagnostics.json"
end
