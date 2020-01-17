defmodule AutoApi.TrunkCapability do
  @moduledoc """
  Basic settings for Trunk Capability

      iex> alias AutoApi.TrunkCapability, as: T
      iex> T.identifier
      <<0x00, 0x21>>
      iex> T.name
      :trunk
      iex> T.description
      "Trunk"
      iex> length(T.properties)
      2
      iex> T.properties
      [{1, :lock}, {2, :position}]
  """

  @command_module AutoApi.TrunkCommand
  @state_module AutoApi.TrunkState

  use AutoApi.Capability, spec_file: "specs/trunk.json"
end
