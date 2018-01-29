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
defmodule AutoApi.MessagingCapability do
  @moduledoc """
  Basic settings for Messaging Capability

      iex> alias AutoApi.MessagingCapability, as: M
      iex> M.identifier
      <<0x00, 0x37>>
      iex> M.name
      :messaging
      iex> M.description
      "Messaging"
      iex> M.command_name(0x00)
      :message_received
      iex> M.command_name(0x01)
      :send_message
      iex> length(M.properties)
      0
  """

  @spec_file "specs/messaging.json"
  @type command_type :: :message_received | :send_message

  @command_module AutoApi.NotImplemented
  @state_module AutoApi.NotImplemented

  use AutoApi.Capability
end