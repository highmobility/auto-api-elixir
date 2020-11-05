defmodule AutoApiL11.WindscreenCapability do
  @moduledoc """
  Basic settings for Windscreen Capability

      iex> alias AutoApiL11.WindscreenCapability, as: W
      iex> W.identifier
      <<0x00, 0x42>>
      iex> W.name
      :windscreen
      iex> W.description
      "Windscreen"
      iex> length(W.properties)
      8
      iex> List.last(W.properties)
      {0x08, :windscreen_damage_detection_time}
  """

  @command_module AutoApiL11.WindscreenCommand
  @state_module AutoApiL11.WindscreenState

  use AutoApiL11.Capability, spec_file: "specs/windscreen.json"
end
