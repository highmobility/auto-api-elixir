defmodule AutoApiL11.BrowserCapability do
  @moduledoc """
  Basic settings for Browser Capability

      iex> alias AutoApiL11.BrowserCapability, as: B
      iex> B.identifier
      <<0x00, 0x49>>
      iex> B.name
      :browser
      iex> B.description
      "Browser"
      iex> length(B.properties)
      1
  """

  @command_module AutoApiL11.BrowserCommand
  @state_module AutoApiL11.BrowserState

  use AutoApiL11.Capability, spec_file: "specs/browser.json"
end
