defmodule AutoApi.WindscreenCapability do
  @moduledoc """
  Basic settings for Windscreen Capability

      iex> alias AutoApi.WindscreenCapability, as: W
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

  @command_module AutoApi.WindscreenCommand
  @state_module AutoApi.WindscreenState

  use AutoApi.Capability, spec_file: "windscreen.json"
end
