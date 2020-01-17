defmodule AutoApi.HeartRateCapability do
  @moduledoc """
  Basic settings for Heart Rate Capability

      iex> alias AutoApi.HeartRateCapability, as: H
      iex> H.identifier
      <<0x00, 0x29>>
      iex> H.name
      :heart_rate
      iex> H.description
      "Heart Rate"
      iex> length(H.properties)
      1
  """

  @command_module AutoApi.HeartRateCommand
  @state_module AutoApi.HeartRateState

  use AutoApi.Capability, spec_file: "specs/heart_rate.json"
end
