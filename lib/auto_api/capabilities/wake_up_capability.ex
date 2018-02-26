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
defmodule AutoApi.WakeUpCapability do
  @moduledoc """
  Basic settings for Wake Up Capability

      iex> alias AutoApi.WakeUpCapability, as: W
      iex> W.identifier
      <<0x00, 0x22>>
      iex> W.name
      :wake_up
      iex> W.description
      "Wake Up"
      iex> W.command_name(0x02)
      :wake_up
      iex> length(W.properties)
      0
  """

  @spec_file "specs/wake_up.json"
  @type command_type :: :wake_up

  @command_module AutoApi.NotImplemented
  @state_module AutoApi.NotImplemented

  use AutoApi.Capability
end
