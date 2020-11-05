defmodule AutoApiL11.HeartRateCapability do
  @moduledoc """
  Basic settings for Heart Rate Capability

      iex> alias AutoApiL11.HeartRateCapability, as: H
      iex> H.identifier
      <<0x00, 0x29>>
      iex> H.name
      :heart_rate
      iex> H.description
      "Heart Rate"
      iex> length(H.properties)
      1
  """

  @command_module AutoApiL11.HeartRateCommand
  @state_module AutoApiL11.HeartRateState

  use AutoApiL11.Capability, spec_file: "specs/heart_rate.json"
end
