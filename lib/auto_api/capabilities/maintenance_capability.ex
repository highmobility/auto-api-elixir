defmodule AutoApiL11.MaintenanceCapability do
  @moduledoc """
  Basic settings for Maintenance Capability

      iex> alias AutoApiL11.MaintenanceCapability, as: M
      iex> M.identifier
      <<0x00, 0x34>>
      iex> M.name
      :maintenance
      iex> M.description
      "Maintenance"
      iex> length(M.properties)
      12
  """

  @command_module AutoApiL11.MaintenanceCommand
  @state_module AutoApiL11.MaintenanceState

  use AutoApiL11.Capability, spec_file: "specs/maintenance.json"
end
