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
defmodule AutoApi.HeartRateCapability do
  @moduledoc """
  Basic settings for Heart Rate Capability

      iex> alias AutoApi.HeartRateCapability, as: H
      iex> H.identifier
      <<0x00, 0x29>>
      iex> H.name
      :heart_rate
      iex> H.description
      "Heart Rate"
      iex> H.command_name(0x12)
      :send_heart_rate
      iex> length(H.properties)
      0
  """

  @spec_file "specs/heart_rate.json"
  @type command_type :: :send_heart_rate

  @command_module AutoApi.NotImplemented
  @state_module AutoApi.NotImplemented

  use AutoApi.Capability
end
