defmodule AutoApi.TachographCapability do
  @moduledoc """
  Basic settings for Tachograph Capability

      iex> alias AutoApi.TachographCapability, as: T
      iex> T.identifier
      <<0x00, 0x64>>
      iex> T.name
      :tachograph
      iex> T.description
      "Tachograph"
      iex> length(T.properties)
      7
      iex> List.last(T.properties)
      {7, :vehicle_speed}
  """

  @command_module AutoApi.TachographCommand
  @state_module AutoApi.TachographState

  use AutoApi.Capability, spec_file: "tachograph.json"
end
