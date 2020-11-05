defmodule AutoApiL11.ChargingCapability do
  @moduledoc """
  Basic settings for Charging Capability

      iex> alias AutoApiL11.ChargingCapability, as: C
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

  @command_module AutoApiL11.ChargingCommand
  @state_module AutoApiL11.ChargingState

  use AutoApiL11.Capability, spec_file: "specs/charging.json"
end
