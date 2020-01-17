defmodule AutoApi.CruiseControlCapability do
  @moduledoc """
  Basic settings for Cruise Control Capability

      iex> alias AutoApi.CruiseControlCapability, as: CC
      iex> CC.identifier
      <<0x00, 0x62>>
      iex> CC.name
      :cruise_control
      iex> CC.description
      "Cruise Control"
      iex> CC.properties
      [{1, :cruise_control}, {2, :limiter}, {3, :target_speed}, {4, :adaptive_cruise_control}, {5, :acc_target_speed}]
  """

  @command_module AutoApi.CruiseControlCommand
  @state_module AutoApi.CruiseControlState

  use AutoApi.Capability, spec_file: "specs/cruise_control.json"
end
