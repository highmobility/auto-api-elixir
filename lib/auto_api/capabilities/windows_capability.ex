defmodule AutoApi.WindowsCapability do
  @moduledoc """
  Basic settings for Windows Capability

      iex> alias AutoApi.WindowsCapability, as: W
      iex> W.identifier
      <<0x00, 0x45>>
      iex> W.name
      :windows
      iex> W.description
      "Windows"
      iex> length(W.properties)
      2
      iex> W.properties
      [{2, :open_percentages}, {3, :positions}]
  """

  @command_module AutoApi.WindowsCommand
  @state_module AutoApi.WindowsState

  use AutoApi.Capability, spec_file: "specs/windows.json"
end
