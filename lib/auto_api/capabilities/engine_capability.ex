defmodule AutoApiL11.EngineCapability do
  @moduledoc """
  Basic settings for Engine Capability

      iex> alias AutoApiL11.EngineCapability, as: E
      iex> E.identifier
      <<0x00, 0x69>>
      iex> E.name
      :engine
      iex> E.description
      "Engine"
      iex> E.properties
      [{1, :status}]
  """

  @command_module AutoApiL11.EngineCommand
  @state_module AutoApiL11.EngineState

  use AutoApiL11.Capability, spec_file: "specs/engine.json"
end
