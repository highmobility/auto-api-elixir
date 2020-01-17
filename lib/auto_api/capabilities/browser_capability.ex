defmodule AutoApi.BrowserCapability do
  @moduledoc """
  Basic settings for Browser Capability

      iex> alias AutoApi.BrowserCapability, as: B
      iex> B.identifier
      <<0x00, 0x49>>
      iex> B.name
      :browser
      iex> B.description
      "Browser"
      iex> length(B.properties)
      1
  """

  @command_module AutoApi.BrowserCommand
  @state_module AutoApi.BrowserState

  use AutoApi.Capability, spec_file: "specs/browser.json"
end
