defmodule AutoApiL11.VehicleLocationCapability do
  @moduledoc """
  Basic settings for Vehicle Location Capability

      iex> alias AutoApiL11.VehicleLocationCapability, as: VL
      iex> VL.identifier
      <<0x00, 0x30>>
      iex> VL.name
      :vehicle_location
      iex> VL.description
      "Vehicle Location"
      iex> length(VL.properties)
      3
      iex> VL.properties
      [{4, :coordinates}, {5, :heading}, {6, :altitude}]
  """

  @command_module AutoApiL11.VehicleLocationCommand
  @state_module AutoApiL11.VehicleLocationState

  use AutoApiL11.Capability, spec_file: "specs/vehicle_location.json"
end
