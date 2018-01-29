# AutoAPI
# Copyright (C) 2018 High-Mobility GmbH
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see http://www.gnu.org/licenses/.
#
# Please inquire about commercial licensing options at
# licensing@high-mobility.com
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
      iex> T.command_name(0x00)
      :get_theft_alarm_state
      iex> T.command_name(0x01)
      :theft_alarm_state
      iex> T.command_name(0x02)
      :set_theft_alarm_state
      iex> length(T.properties)
      1
      iex> T.properties
      [{1, :theft_alarm}]
  """

  @spec_file "specs/theft_alarm.json"
  @type command_type :: :get_theft_alarm_state | :theft_alarm_state | :set_theft_alarm_state

  @command_module AutoApi.NotImplemented
  @state_module AutoApi.NotImplemented

  use AutoApi.Capability
end
