defmodule AutoApi.RemoteControlCapability do
  @moduledoc """
  Basic settings for RemoteControl Capability

      iex> alias AutoApi.RemoteControlCapability, as: R
      iex> R.identifier
      <<0x00, 0x27>>
      iex> R.name
      :remote_control
      iex> R.description
      "Remote Control"
      iex> length(R.properties)
      3
      iex> R.properties
      [{1, :control_mode}, {2, :angle}, {3, :speed}]
  """

  @command_module AutoApi.RemoteControlCommand
  @state_module AutoApi.RemoteControlState

  use AutoApi.Capability, spec_file: "remote_control.json"
end
