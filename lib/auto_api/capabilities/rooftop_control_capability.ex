defmodule AutoApiL11.RooftopControlCapability do
  @moduledoc """
  Basic settings for RooftopControl Capability

      iex> alias AutoApiL11.RooftopControlCapability, as: R
      iex> R.identifier
      <<0x00, 0x25>>
      iex> R.name
      :rooftop_control
      iex> R.description
      "Rooftop Control"
      iex> length(R.properties)
      5
  """

  @command_module AutoApiL11.RooftopControlCommand
  @state_module AutoApiL11.RooftopControlState

  use AutoApiL11.Capability, spec_file: "specs/rooftop_control.json"
end
