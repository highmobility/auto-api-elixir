defmodule AutoApi.VideoHandoverCapability do
  @moduledoc """
  Basic settings for Video Handover Capability

      iex> alias AutoApi.VideoHandoverCapability, as: VH
      iex> VH.identifier
      <<0x00, 0x43>>
      iex> VH.name
      :video_handover
      iex> VH.description
      "Video Handover"
      iex> length(VH.properties)
      3
  """

  @command_module AutoApi.VideoHandoverCommand
  @state_module AutoApi.VideoHandoverState

  use AutoApi.Capability, spec_file: "specs/video_handover.json"
end
