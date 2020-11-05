defmodule AutoApiL11.MultiCommandCapability do
  @moduledoc """
  Basic settings for MultiCommand Capability

      iex> alias AutoApiL11.MultiCommandCapability, as: M
      iex> M.identifier
      <<0x00, 0x13>>
      iex> M.name
      :multi_command
      iex> M.description
      "Multi Command"
      iex> length(M.properties)
      2
  """

  @command_module AutoApiL11.MultiCommandCommand
  @state_module AutoApiL11.MultiCommandState

  use AutoApiL11.Capability, spec_file: "specs/multi_command.json"
end
