defmodule AutoApiL11.PowerTakeoffCapability do
  @moduledoc """
  Basic settings for Power Takeoff Capability

      iex> alias AutoApiL11.PowerTakeoffCapability, as: PT
      iex> PT.identifier
      <<0x0, 0x65>>
      iex> PT.name
      :power_takeoff
      iex> PT.description
      "Power Take-Off"
      iex> PT.properties
      [{1, :status}, {2, :engaged}]
  """

  @command_module AutoApiL11.PowerTakeoffCommand
  @state_module AutoApiL11.PowerTakeoffState

  use AutoApiL11.Capability, spec_file: "specs/power_takeoff.json"
end
