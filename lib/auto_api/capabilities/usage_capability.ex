defmodule AutoApiL11.UsageCapability do
  @moduledoc """
  Basic settings for usage Capability

      iex> alias AutoApiL11.UsageCapability, as: U
      iex> U.identifier
      <<0x00, 0x68>>
      iex> U.name
      :usage
      iex> U.description
      "Usage"
      iex> length(U.properties)
      0x0E
  """

  @command_module AutoApiL11.UsageCommand
  @state_module AutoApiL11.UsageState

  use AutoApiL11.Capability, spec_file: "specs/usage.json"
end
