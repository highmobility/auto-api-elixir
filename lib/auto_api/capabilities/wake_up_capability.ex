defmodule AutoApiL11.WakeUpCapability do
  @moduledoc """
  Basic settings for Wake Up Capability

      iex> alias AutoApiL11.WakeUpCapability, as: W
      iex> W.identifier
      <<0x00, 0x22>>
      iex> W.name
      :wake_up
      iex> W.description
      "Wake Up"
      iex> length(W.properties)
      1
  """

  @command_module AutoApiL11.WakeUpCommand
  @state_module AutoApiL11.WakeUpState

  use AutoApiL11.Capability, spec_file: "specs/wake_up.json"
end
