defmodule AutoApi.VehicleLocationCapability do
  @moduledoc """
  Basic settings for Vehicle Location Capability

      iex> alias AutoApi.VehicleLocationCapability, as: VL
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

  @command_module AutoApi.VehicleLocationCommand
  @state_module AutoApi.VehicleLocationState

  use AutoApi.Capability, spec_file: "vehicle_location.json"
end
