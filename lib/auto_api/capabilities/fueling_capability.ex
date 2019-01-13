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
defmodule AutoApi.FuelingCapability do
  @moduledoc """
  Basic settings for Fueling Capability

      iex> alias AutoApi.FuelingCapability, as: F
      iex> F.identifier
      <<0x00, 0x40>>
      iex> F.name
      :fueling
      iex> F.description
      "Fueling"
      iex> F.command_name(0x00)
      :get_gas_flap_state
      iex> F.command_name(0x01)
      :gas_flap_state
      iex> F.command_name(0x12)
      :control_gas_flap
      iex> length(F.properties)
      2
      iex> F.properties
      [{2, :gas_flap_lock}, {3, :gas_flap_position}]
  """

  @spec_file "specs/fueling.json"
  @type command_type ::
          :get_gas_flap_state | :gas_flap_state | :open_close_gas_flap | :control_gas_flap

  @command_module AutoApi.FuelingCommand
  @state_module AutoApi.FuelingState

  use AutoApi.Capability
end
