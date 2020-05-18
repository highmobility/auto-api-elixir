defmodule AutoApi.HoodCapability do
  @moduledoc """
  Basic settings for HoodCapability

      iex> alias AutoApi.HoodCapability, as: H
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

  @command_module AutoApi.HoodCommand
  @state_module AutoApi.HoodState

  use AutoApi.Capability, spec_file: "hood.json"
end
