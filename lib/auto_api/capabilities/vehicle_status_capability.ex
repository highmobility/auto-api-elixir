defmodule AutoApi.VehicleStatusCapability do
  @moduledoc """
  Basic settings for Vehicle Status Capability

      iex> alias AutoApi.VehicleStatusCapability, as: VS
      iex> VS.identifier
      <<0x00, 0x11>>
      iex> VS.name
      :vehicle_status
      iex> VS.description
      "Vehicle Status"
      iex> length(VS.properties)
      1
      iex> List.last(VS.properties)
      {0x99, :states}
  """

  @command_module AutoApi.VehicleStatusCommand
  @state_module AutoApi.VehicleStatusState

  use AutoApi.Capability, spec_file: "vehicle_status.json"
end
