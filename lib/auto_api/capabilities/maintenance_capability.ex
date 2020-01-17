defmodule AutoApi.MaintenanceCapability do
  @moduledoc """
  Basic settings for Maintenance Capability

      iex> alias AutoApi.MaintenanceCapability, as: M
      iex> M.identifier
      <<0x00, 0x34>>
      iex> M.name
      :maintenance
      iex> M.description
      "Maintenance"
      iex> length(M.properties)
      12
  """

  @command_module AutoApi.MaintenanceCommand
  @state_module AutoApi.MaintenanceState

  use AutoApi.Capability, spec_file: "specs/maintenance.json"
end
