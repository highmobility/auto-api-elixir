defmodule AutoApi.UsageCapability do
  @moduledoc """
  Basic settings for usage Capability

      iex> alias AutoApi.UsageCapability, as: U
      iex> U.identifier
      <<0x00, 0x68>>
      iex> U.name
      :usage
      iex> U.description
      "Usage"
      iex> length(U.properties)
      0x0E
  """

  @command_module AutoApi.UsageCommand
  @state_module AutoApi.UsageState

  use AutoApi.Capability, spec_file: "usage.json"
end
