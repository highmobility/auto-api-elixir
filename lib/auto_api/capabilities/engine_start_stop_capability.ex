defmodule AutoApiL11.EngineStartStopCapability do
  @moduledoc """
  Basic settings for Vehicle Status Capability

      iex> alias AutoApiL11.EngineStartStopCapability, as: SS
      iex> SS.identifier
      <<0x00, 0x63>>
      iex> SS.name
      :engine_start_stop
      iex> SS.description
      "Engine Start-Stop"
      iex> SS.properties
      [{1, :status}]
  """

  @command_module AutoApiL11.NotImplemented
  @state_module AutoApiL11.EngineStartStopState

  use AutoApiL11.Capability, spec_file: "specs/engine_start_stop.json"
end
