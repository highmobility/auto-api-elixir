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
defmodule AutoApi.NotificationsCapability do
  @moduledoc """
  Basic settings for Notifications Capability

      iex> alias AutoApi.NotificationsCapability, as: N
      iex> N.identifier
      <<0x00, 0x38>>
      iex> N.name
      :notifications
      iex> N.description
      "Notifications"
      iex> N.command_name(0x00)
      :notification
      iex> N.command_name(0x02)
      :clear_notification
      iex> N.command_name(0x11)
      :notification_action
      iex> length(N.properties)
      3
  """

  @spec_file "specs/notifications.json"
  @type command_type :: :notification | :notification_action | :clear_notification

  @command_module AutoApi.NotImplemented
  @state_module AutoApi.NotImplemented

  use AutoApi.Capability
end
