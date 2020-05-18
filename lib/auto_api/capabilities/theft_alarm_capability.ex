defmodule AutoApi.TheftAlarmCapability do
  @moduledoc """
  Basic settings for TheftAlarm Capability

      iex> alias AutoApi.TheftAlarmCapability, as: T
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

  @command_module AutoApi.TheftAlarmCommand
  @state_module AutoApi.TheftAlarmState

  use AutoApi.Capability, spec_file: "theft_alarm.json"
end
