defmodule AutoApiL11.RemoteControlCapability do
  @moduledoc """
  Basic settings for RemoteControl Capability

      iex> alias AutoApiL11.RemoteControlCapability, as: R
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

  @command_module AutoApiL11.RemoteControlCommand
  @state_module AutoApiL11.RemoteControlState

  use AutoApiL11.Capability, spec_file: "specs/remote_control.json"
end
