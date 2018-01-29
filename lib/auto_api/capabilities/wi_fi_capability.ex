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
defmodule AutoApi.WiFiCapability do
  @moduledoc """
  Basic settings for WiFi Capability

      iex> alias AutoApi.WiFiCapability, as: W
      iex> W.identifier
      <<0x00, 0x59>>
      iex> W.name
      :wi_fi
      iex> W.description
      "Wi-Fi"
      iex> W.command_name(0x00)
      :get_wi_fi_state
      iex> W.command_name(0x01)
      :wi_fi_state
      iex> W.command_name(0x02)
      :connect_to_network
      iex> W.command_name(0x03)
      :forget_network
      iex> W.command_name(0x04)
      :enable_disable_wi_fi
      iex> length(W.properties)
      4
      iex> W.properties
      [{1, :wi_fi_enabled}, {2, :network_connected}, {3, :network_ssid}, {4, :network_security}]
  """

  @spec_file "specs/wi_fi.json"
  @type command_type ::
          :get_wi_fi_state
          | :wi_fi_state
          | :connect_to_network
          | :forget_network
          | :enable_disable_wi_fi

  @command_module AutoApi.NotImplemented
  @state_module AutoApi.NotImplemented

  use AutoApi.Capability
end
