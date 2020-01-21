defmodule AutoApi.TextInputCapability do
  @moduledoc """
  Basic settings for TextInput Capability

      iex> alias AutoApi.TextInputCapability, as: T
      iex> T.identifier
      <<0x00, 0x44>>
      iex> T.name
      :text_input
      iex> T.description
      "Text Input"
      iex> length(T.properties)
      1
  """

  @command_module AutoApi.TextInputCommand
  @state_module AutoApi.TextInputState

  use AutoApi.Capability, spec_file: "specs/text_input.json"
end
