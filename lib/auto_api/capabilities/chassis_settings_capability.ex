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
defmodule AutoApi.ChassisSettingsCapability do
  @moduledoc """
  Basic settings for Chassis Settings Capability

      iex> alias AutoApi.ChassisSettingsCapability, as: C
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

  @type command_type ::
          :get_chassis_settings
          | :chassis_settings
          | :set_driving_mode
          | :start_stop_sport_chrono
          | :set_spring_rate
          | :set_chassis_position

  @command_module AutoApi.NotImplemented
  @state_module AutoApi.ChassisSettingsState

  use AutoApi.Capability, spec_file: "specs/chassis_settings.json"
end
