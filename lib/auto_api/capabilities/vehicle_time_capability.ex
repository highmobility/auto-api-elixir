defmodule AutoApi.VehicleTimeCapability do
  @moduledoc """
  Basic settings for Vehicle Time Capability

      iex> alias AutoApi.VehicleTimeCapability, as: VT
      iex> VT.identifier
      <<0x00, 0x50>>
      iex> VT.name
      :vehicle_time
      iex> VT.description
      "Vehicle Time"
      iex> length(VT.properties)
      1
  """

  @command_module AutoApi.VehicleTimeCommand
  @state_module AutoApi.VehicleTimeState

  use AutoApi.Capability, spec_file: "vehicle_time.json"
end
