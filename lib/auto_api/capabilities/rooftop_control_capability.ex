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
defmodule AutoApi.RooftopControlCapability do
  @moduledoc """
  Basic settings for RooftopControl Capability

      iex> alias AutoApi.RooftopControlCapability, as: R
      iex> R.identifier
      <<0x00, 0x25>>
      iex> R.name
      :rooftop_control
      iex> R.description
      "Rooftop Control"
      iex> R.command_name(0x00)
      :get_rooftop_state
      iex> R.command_name(0x01)
      :rooftop_state
      iex> R.command_name(0x12)
      :control_rooftop
      iex> length(R.properties)
      5
  """

  @spec_file "specs/rooftop_control.json"
  @type command_type :: :get_rooftop_state | :rooftop_state | :control_rooftop

  @command_module AutoApi.RooftopControlCommand
  @state_module AutoApi.RooftopControlState

  use AutoApi.Capability
end
