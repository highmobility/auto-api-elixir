defmodule AutoApi.WakeUpCapability do
  @moduledoc """
  Basic settings for Wake Up Capability

      iex> alias AutoApi.WakeUpCapability, as: W
      iex> W.identifier
      <<0x00, 0x22>>
      iex> W.name
      :wake_up
      iex> W.description
      "Wake Up"
      iex> length(W.properties)
      1
  """

  @command_module AutoApi.WakeUpCommand
  @state_module AutoApi.WakeUpState

  use AutoApi.Capability, spec_file: "specs/wake_up.json"
end
