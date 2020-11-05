defmodule AutoApiL11.VehicleStatusCapability do
  @moduledoc """
  Basic settings for Vehicle Status Capability

      iex> alias AutoApiL11.VehicleStatusCapability, as: VS
      iex> VS.identifier
      <<0x00, 0x11>>
      iex> VS.name
      :vehicle_status
      iex> VS.description
      "Vehicle Status"
      iex> length(VS.properties)
      19
      iex> List.last(VS.properties)
      {153, :states}
  """

  @command_module AutoApiL11.VehicleStatusCommand
  @state_module AutoApiL11.VehicleStatusState

  use AutoApiL11.Capability, spec_file: "specs/vehicle_status.json"
end
