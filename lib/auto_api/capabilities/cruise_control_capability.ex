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
defmodule AutoApi.CruiseControlCapability do
  @moduledoc """
  Basic settings for Cruise Control Capability

      iex> alias AutoApi.CruiseControlCapability, as: CC
      iex> CC.identifier
      <<0x00, 0x62>>
      iex> CC.name
      :cruise_control
      iex> CC.description
      "Cruise Control"
      iex> CC.command_name(0x00)
      :get_cruise_control_state
      iex> CC.command_name(0x01)
      :cruise_control_state
      iex> CC.command_name(0x12)
      :activate_deactivate_cruise_control
      iex> CC.properties
      [{1, :cruise_control}, {2, :limiter}, {3, :target_speed}, {4, :acc}, {5, :acc_target_speed}]
  """

  @spec_file "specs/cruise_control.json"
  @type command_type ::
          :get_cruise_control_state | :cruise_control_state | :activate_deactivate_cruise_control

  @command_module AutoApi.CruiseControlCommand
  @state_module AutoApi.CruiseControlState

  use AutoApi.Capability
end
