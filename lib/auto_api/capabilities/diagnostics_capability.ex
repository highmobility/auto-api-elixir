defmodule AutoApi.DiagnosticsCapability do
  @moduledoc """
  Basic settings for Diagnostics Capability

      iex> alias AutoApi.DiagnosticsCapability, as: D
      iex> D.identifier
      <<0x00, 0x33>>
      iex> D.name
      :diagnostics
      iex> D.description
      "Diagnostics"
      iex> length(D.properties)
      27
  """

  @command_module AutoApi.DiagnosticsCommand
  @state_module AutoApi.DiagnosticsState

  use AutoApi.Capability, spec_file: "diagnostics.json"
end
