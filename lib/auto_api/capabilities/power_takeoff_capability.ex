defmodule AutoApi.PowerTakeoffCapability do
  @moduledoc """
  Basic settings for Power Takeoff Capability

      iex> alias AutoApi.PowerTakeoffCapability, as: PT
      iex> PT.identifier
      <<0x0, 0x65>>
      iex> PT.name
      :power_takeoff
      iex> PT.description
      "Power Take-Off"
      iex> PT.properties
      [{1, :status}, {2, :engaged}]
  """

  @command_module AutoApi.PowerTakeoffCommand
  @state_module AutoApi.PowerTakeoffState

  use AutoApi.Capability, spec_file: "power_takeoff.json"
end
