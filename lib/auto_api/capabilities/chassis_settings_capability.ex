defmodule AutoApi.ChassisSettingsCapability do
  @moduledoc """
  Basic settings for Chassis Settings Capability

      iex> alias AutoApi.ChassisSettingsCapability, as: C
      iex> C.identifier
      <<0x00, 0x53>>
      iex> C.name
      :chassis_settings
      iex> C.description
      "Chassis Settings"
      iex> length(C.properties)
      8
      iex> List.last(C.properties)
      {0x0A, :minimum_chassis_position}
  """

  @command_module AutoApi.ChassisSettingsCommand
  @state_module AutoApi.ChassisSettingsState

  use AutoApi.Capability, spec_file: "chassis_settings.json"
end
