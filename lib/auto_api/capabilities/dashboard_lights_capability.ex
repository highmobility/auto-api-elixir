defmodule AutoApi.DashboardLightsCapability do
  @moduledoc """
  Basic settings for Browser Capability

      iex> alias AutoApi.DashboardLightsCapability, as: F
      iex> F.identifier
      <<0x00, 0x61>>
      iex> F.name
      :dashboard_lights
      iex> F.description
      "Dashboard Lights"
      iex> F.properties
      [{0x01, :dashboard_lights}]
  """

  @command_module AutoApi.DashboardLightsCommand
  @state_module AutoApi.DashboardLightsState

  use AutoApi.Capability, spec_file: "specs/dashboard_lights.json"
end
