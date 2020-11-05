defmodule AutoApiL11.ChassisSettingsCapability do
  @moduledoc """
  Basic settings for Chassis Settings Capability

      iex> alias AutoApiL11.ChassisSettingsCapability, as: C
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

  @command_module AutoApiL11.ChassisSettingsCommand
  @state_module AutoApiL11.ChassisSettingsState

  use AutoApiL11.Capability, spec_file: "specs/chassis_settings.json"
end
