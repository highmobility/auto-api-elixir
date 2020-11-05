defmodule AutoApiL11.HoodCapability do
  @moduledoc """
  Basic settings for HoodCapability

      iex> alias AutoApiL11.HoodCapability, as: H
      iex> H.identifier
      <<0x00, 0x67>>
      iex> H.capability_size
      1
      iex> H.name
      :hood
      iex> H.description
      "Hood"
      iex> length(H.properties)
      0
  """

  @command_module AutoApiL11.HoodCommand
  @state_module AutoApiL11.HoodState

  use AutoApiL11.Capability, spec_file: "specs/hood.json"
end
