defmodule AutoApiL11.FuelingCapability do
  @moduledoc """
  Basic settings for Fueling Capability

      iex> alias AutoApiL11.FuelingCapability, as: F
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

  @command_module AutoApiL11.FuelingCommand
  @state_module AutoApiL11.FuelingState

  use AutoApiL11.Capability, spec_file: "specs/fueling.json"
end
