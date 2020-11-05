defmodule AutoApiL11.TrunkCapability do
  @moduledoc """
  Basic settings for Trunk Capability

      iex> alias AutoApiL11.TrunkCapability, as: T
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

  @command_module AutoApiL11.TrunkCommand
  @state_module AutoApiL11.TrunkState

  use AutoApiL11.Capability, spec_file: "specs/trunk.json"
end
