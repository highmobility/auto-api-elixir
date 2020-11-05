defmodule AutoApiL11.DriverFatigueCapability do
  @moduledoc """
  Basic settings for Driver Fatigue Capability

      iex> alias AutoApiL11.DriverFatigueCapability, as: D
      iex> D.identifier
      <<0x00, 0x41>>
      iex> D.name
      :driver_fatigue
      iex> D.description
      "Driver Fatigue"
      iex> length(D.properties)
      1
  """

  @command_module AutoApiL11.DriverFatigueCommand
  @state_module AutoApiL11.DriverFatigueState

  use AutoApiL11.Capability, spec_file: "specs/driver_fatigue.json"
end
