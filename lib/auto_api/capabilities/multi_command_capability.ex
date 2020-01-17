defmodule AutoApi.MultiCommandCapability do
  @moduledoc """
  Basic settings for MultiCommand Capability

      iex> alias AutoApi.MultiCommandCapability, as: M
      iex> M.identifier
      <<0x00, 0x13>>
      iex> M.name
      :multi_command
      iex> M.description
      "Multi Command"
      iex> length(M.properties)
      2
  """

  @command_module AutoApi.MultiCommandCommand
  @state_module AutoApi.MultiCommandState

  use AutoApi.Capability, spec_file: "specs/multi_command.json"
end
