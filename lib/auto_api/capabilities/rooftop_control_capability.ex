defmodule AutoApi.RooftopControlCapability do
  @moduledoc """
  Basic settings for RooftopControl Capability

      iex> alias AutoApi.RooftopControlCapability, as: R
      iex> R.identifier
      <<0x00, 0x25>>
      iex> R.name
      :rooftop_control
      iex> R.description
      "Rooftop Control"
      iex> length(R.properties)
      5
  """

  @command_module AutoApi.RooftopControlCommand
  @state_module AutoApi.RooftopControlState

  use AutoApi.Capability, spec_file: "rooftop_control.json"
end
