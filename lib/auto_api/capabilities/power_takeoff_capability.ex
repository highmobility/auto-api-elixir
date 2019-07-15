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
defmodule AutoApi.PowerTakeoffCapability do
  @moduledoc """
  Basic settings for Power Takeoff Capability

      iex> alias AutoApi.PowerTakeoffCapability, as: PT
      iex> PT.identifier
      <<0x0, 0x65>>
      iex> PT.name
      :power_takeoff
      iex> PT.description
      "Power Takeoff"
      iex> PT.properties
      [{1, :power_takeoff}, {2, :power_takeoff_engaged}]
  """

  @spec_file "specs/power_takeoff.json"
  @type command_type ::
          :get_power_takeoff_state | :power_takeoff_state | :activate_deactivate_power_takeoff

  @command_module AutoApi.PowerTakeoffCommand
  @state_module AutoApi.PowerTakeoffState

  use AutoApi.Capability
end
