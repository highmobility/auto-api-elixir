defmodule AutoApi.IgnitionCapability do
  @moduledoc """
  Basic settings for Ignition Capability

      iex> alias AutoApi.IgnitionCapability, as: E
      iex> E.identifier
      <<0x00, 0x35>>
      iex> E.name
      :ignition
      iex> E.description
      "Ignition"
      iex> List.last(E.properties)
      {2, :accessories_status}
  """

  @command_module AutoApi.IgnitionCommand
  @state_module AutoApi.IgnitionState

  use AutoApi.Capability, spec_file: "ignition.json"
end
