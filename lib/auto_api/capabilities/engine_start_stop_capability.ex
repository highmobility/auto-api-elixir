defmodule AutoApi.EngineStartStopCapability do
  @moduledoc """
  Basic settings for Vehicle Status Capability

      iex> alias AutoApi.EngineStartStopCapability, as: SS
      iex> SS.identifier
      <<0x00, 0x63>>
      iex> SS.name
      :engine_start_stop
      iex> SS.description
      "Engine Start-Stop"
      iex> SS.properties
      [{1, :status}]
  """

  @command_module AutoApi.NotImplemented
  @state_module AutoApi.EngineStartStopState

  use AutoApi.Capability, spec_file: "specs/engine_start_stop.json"
end
