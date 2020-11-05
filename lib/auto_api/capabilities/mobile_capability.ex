defmodule AutoApiL11.MobileCapability do
  @moduledoc """
  Basic settings for Mobile Capability

      iex> alias AutoApiL11.MobileCapability, as: M
      iex> M.identifier
      <<0x00, 0x66>>
      iex> M.name
      :mobile
      iex> M.description
      "Mobile"
      iex> length(M.properties)
      1
  """

  @command_module AutoApiL11.MobileCommand
  @state_module AutoApiL11.MobileState

  use AutoApiL11.Capability, spec_file: "specs/mobile.json"
end
