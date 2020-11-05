defmodule AutoApiL11.CruiseControlCapability do
  @moduledoc """
  Basic settings for Cruise Control Capability

      iex> alias AutoApiL11.CruiseControlCapability, as: CC
      iex> CC.identifier
      <<0x00, 0x62>>
      iex> CC.name
      :cruise_control
      iex> CC.description
      "Cruise Control"
      iex> CC.properties
      [{1, :cruise_control}, {2, :limiter}, {3, :target_speed}, {4, :adaptive_cruise_control}, {5, :acc_target_speed}]
  """

  @command_module AutoApiL11.CruiseControlCommand
  @state_module AutoApiL11.CruiseControlState

  use AutoApiL11.Capability, spec_file: "specs/cruise_control.json"
end
