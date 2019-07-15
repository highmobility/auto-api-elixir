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
defmodule AutoApi.RemoteControlCapability do
  @moduledoc """
  Basic settings for RemoteControl Capability

      iex> alias AutoApi.RemoteControlCapability, as: R
      iex> R.identifier
      <<0x00, 0x27>>
      iex> R.name
      :remote_control
      iex> R.description
      "Remote Control"
      iex> length(R.properties)
      2
      iex> R.properties
      [{1, :control_mode}, {2, :angle}]
  """

  @spec_file "specs/remote_control.json"
  @type command_type ::
          :get_control_mode
          | :control_mode
          | :start_stop_control

  @command_module AutoApi.NotImplemented
  @state_module AutoApi.RemoteControlState

  use AutoApi.Capability
end
