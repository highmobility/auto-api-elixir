defmodule AutoApiL11.VideoHandoverCapability do
  @moduledoc """
  Basic settings for Video Handover Capability

      iex> alias AutoApiL11.VideoHandoverCapability, as: VH
      iex> VH.identifier
      <<0x00, 0x43>>
      iex> VH.name
      :video_handover
      iex> VH.description
      "Video Handover"
      iex> length(VH.properties)
      3
  """

  @command_module AutoApiL11.VideoHandoverCommand
  @state_module AutoApiL11.VideoHandoverState

  use AutoApiL11.Capability, spec_file: "specs/video_handover.json"
end
