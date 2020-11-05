defmodule AutoApiL11.TextInputCapability do
  @moduledoc """
  Basic settings for TextInput Capability

      iex> alias AutoApiL11.TextInputCapability, as: T
      iex> T.identifier
      <<0x00, 0x44>>
      iex> T.name
      :text_input
      iex> T.description
      "Text Input"
      iex> length(T.properties)
      1
  """

  @command_module AutoApiL11.TextInputCommand
  @state_module AutoApiL11.TextInputState

  use AutoApiL11.Capability, spec_file: "specs/text_input.json"
end
