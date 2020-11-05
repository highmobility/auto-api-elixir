defmodule AutoApiL11.IgnitionCapability do
  @moduledoc """
  Basic settings for Ignition Capability

      iex> alias AutoApiL11.IgnitionCapability, as: E
      iex> E.identifier
      <<0x00, 0x35>>
      iex> E.name
      :ignition
      iex> E.description
      "Ignition"
      iex> List.last(E.properties)
      {2, :accessories_status}
  """

  @command_module AutoApiL11.IgnitionCommand
  @state_module AutoApiL11.IgnitionState

  use AutoApiL11.Capability, spec_file: "specs/ignition.json"
end
