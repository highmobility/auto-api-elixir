defmodule AutoApi.DriverFatigueCapability do
  @moduledoc """
  Basic settings for Driver Fatigue Capability

      iex> alias AutoApi.DriverFatigueCapability, as: D
      iex> D.identifier
      <<0x00, 0x41>>
      iex> D.name
      :driver_fatigue
      iex> D.description
      "Driver Fatigue"
      iex> length(D.properties)
      1
  """

  @command_module AutoApi.DriverFatigueCommand
  @state_module AutoApi.DriverFatigueState

  use AutoApi.Capability, spec_file: "driver_fatigue.json"
end
