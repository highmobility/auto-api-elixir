defmodule AutoApi.ChargingCapability do
  @moduledoc """
  Basic settings for Charging Capability

      iex> alias AutoApi.ChargingCapability, as: C
      iex> C.identifier
      <<0x00, 0x23>>
      iex> C.name
      :charging
      iex> C.description
      "Charging"
      iex> length(C.properties)
      20
      iex> List.last(C.properties)
      {23, :status}
  """

  @command_module AutoApi.ChargingCommand
  @state_module AutoApi.ChargingState

  use AutoApi.Capability, spec_file: "specs/charging.json"
end
