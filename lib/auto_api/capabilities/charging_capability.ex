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
defmodule AutoApi.ChargingCapability do
  @moduledoc """
  Basic settings for Charging Capability

      iex> alias AutoApi.ChargingCapability, as: C
      iex> C.identifier
      <<0x00, 0x23>>
      iex> C.name
      :charging
      iex> C.description
      "Charging"
      iex> C.command_name(0x00)
      :get_charge_state
      iex> C.command_name(0x01)
      :charge_state
      iex> C.command_name(0x12)
      :start_stop_charging
      iex> C.command_name(0x13)
      :set_charge_limit
      iex> C.command_name(0x14)
      :open_close_charging_port
      iex> C.command_name(0x15)
      :set_charge_mode
      iex> C.command_name(0x16)
      :set_charging_timers
      iex> C.command_name(0x17)
      :set_reduction_of_charging_current_times
      iex> length(C.properties)
      20
      iex> List.last(C.properties)
      {23, :charging_state}
  """

  @spec_file "specs/charging.json"
  @type command_type ::
          :get_charge_state
          | :charge_state
          | :start_stop_charging
          | :set_charge_limit
          | :open_close_charge_port
          | :set_charge_mode
          | :set_charge_timer

  @command_module AutoApi.ChargingCommand
  @state_module AutoApi.ChargingState

  use AutoApi.Capability
end
