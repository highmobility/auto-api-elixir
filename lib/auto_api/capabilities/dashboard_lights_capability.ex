defmodule AutoApiL11.DashboardLightsCapability do
  @moduledoc """
  Basic settings for Browser Capability

      iex> alias AutoApiL11.DashboardLightsCapability, as: F
      iex> F.identifier
      <<0x00, 0x61>>
      iex> F.name
      :dashboard_lights
      iex> F.description
      "Dashboard Lights"
      iex> F.properties
      [{0x01, :dashboard_lights}]
  """

  @command_module AutoApiL11.DashboardLightsCommand
  @state_module AutoApiL11.DashboardLightsState

  use AutoApiL11.Capability, spec_file: "specs/dashboard_lights.json"
end
