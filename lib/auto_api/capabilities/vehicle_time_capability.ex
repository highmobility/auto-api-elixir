defmodule AutoApiL11.VehicleTimeCapability do
  @moduledoc """
  Basic settings for Vehicle Time Capability

      iex> alias AutoApiL11.VehicleTimeCapability, as: VT
      iex> VT.identifier
      <<0x00, 0x50>>
      iex> VT.name
      :vehicle_time
      iex> VT.description
      "Vehicle Time"
      iex> length(VT.properties)
      1
  """

  @command_module AutoApiL11.VehicleTimeCommand
  @state_module AutoApiL11.VehicleTimeState

  use AutoApiL11.Capability, spec_file: "specs/vehicle_time.json"
end
