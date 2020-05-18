defmodule AutoApi.EngineCapability do
  @moduledoc """
  Basic settings for Engine Capability

      iex> alias AutoApi.EngineCapability, as: E
      iex> E.identifier
      <<0x00, 0x69>>
      iex> E.name
      :engine
      iex> E.description
      "Engine"
      iex> E.properties
      [{1, :status}]
  """

  @command_module AutoApi.EngineCommand
  @state_module AutoApi.EngineState

  use AutoApi.Capability, spec_file: "engine.json"
end
