defmodule AutoApiL11.TheftAlarmCapability do
  @moduledoc """
  Basic settings for TheftAlarm Capability

      iex> alias AutoApiL11.TheftAlarmCapability, as: T
      iex> T.identifier
      <<0x00, 0x46>>
      iex> T.name
      :theft_alarm
      iex> T.description
      "Theft Alarm"
      iex> length(T.properties)
      1
      iex> T.properties
      [{1, :status}]
  """

  @command_module AutoApiL11.TheftAlarmCommand
  @state_module AutoApiL11.TheftAlarmState

  use AutoApiL11.Capability, spec_file: "specs/theft_alarm.json"
end
