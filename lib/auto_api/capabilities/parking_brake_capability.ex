defmodule AutoApiL11.ParkingBrakeCapability do
  @moduledoc """
  Basic settings for ParkingBrake Capability

      iex> alias AutoApiL11.ParkingBrakeCapability, as: P
      iex> P.identifier
      <<0x00, 0x58>>
      iex> P.name
      :parking_brake
      iex> P.description
      "Parking Brake"
      iex> length(P.properties)
      1
      iex> P.properties
      [{1, :status}]
  """

  @command_module AutoApiL11.ParkingBrakeCommand
  @state_module AutoApiL11.ParkingBrakeState

  use AutoApiL11.Capability, spec_file: "specs/parking_brake.json"
end
