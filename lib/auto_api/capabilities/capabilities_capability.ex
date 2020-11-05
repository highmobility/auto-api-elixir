defmodule AutoApiL11.CapabilitiesCapability do
  @moduledoc """
  Basic settings for Capabilities "Capability".

      iex> alias AutoApiL11.CapabilitiesCapability, as: C
      iex> C.identifier
      <<0x00, 0x10>>
      iex> C.name
      :capabilities
      iex> C.description
      "Capabilities"
      iex> List.last(C.properties)
      {0x01, :capabilities}
  """

  @command_module AutoApiL11.CapabilitiesCommand
  @state_module AutoApiL11.CapabilitiesState

  use AutoApiL11.Capability, spec_file: "specs/capabilities.json"
end
