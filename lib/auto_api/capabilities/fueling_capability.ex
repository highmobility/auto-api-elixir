defmodule AutoApi.FuelingCapability do
  @moduledoc """
  Basic settings for Fueling Capability

      iex> alias AutoApi.FuelingCapability, as: F
      iex> F.identifier
      <<0x00, 0x40>>
      iex> F.name
      :fueling
      iex> F.description
      "Fueling"
      iex> length(F.properties)
      2
      iex> F.properties
      [{2, :gas_flap_lock}, {3, :gas_flap_position}]
  """

  @command_module AutoApi.FuelingCommand
  @state_module AutoApi.FuelingState

  use AutoApi.Capability, spec_file: "fueling.json"
end
