defmodule AutoApiL11.TachographCapability do
  @moduledoc """
  Basic settings for Tachograph Capability

      iex> alias AutoApiL11.TachographCapability, as: T
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

  @command_module AutoApiL11.TachographCommand
  @state_module AutoApiL11.TachographState

  use AutoApiL11.Capability, spec_file: "specs/tachograph.json"
end
