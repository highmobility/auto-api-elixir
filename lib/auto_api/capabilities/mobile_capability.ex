defmodule AutoApi.MobileCapability do
  @moduledoc """
  Basic settings for Mobile Capability

      iex> alias AutoApi.MobileCapability, as: M
      iex> M.identifier
      <<0x00, 0x66>>
      iex> M.name
      :mobile
      iex> M.description
      "Mobile"
      iex> length(M.properties)
      1
  """

  @command_module AutoApi.MobileCommand
  @state_module AutoApi.MobileState

  use AutoApi.Capability, spec_file: "specs/mobile.json"
end
