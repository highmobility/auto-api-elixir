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
defmodule AutoApi.ClimateCapability do
  @moduledoc """
  Basic settings for Climate Capability

      iex> alias AutoApi.ClimateCapability, as: C
      iex> C.identifier
      <<0x00, 0x24>>
      iex> C.name
      :climate
      iex> C.description
      "Climate"
      iex> C.command_name(0x00)
      :get_climate_state
      iex> C.command_name(0x01)
      :climate_state
      iex> C.command_name(0x02)
      :set_climate_profile
      iex> C.command_name(0x03)
      :start_stop_hvac
      iex> C.command_name(0x04)
      :start_stop_defogging
      iex> C.command_name(0x05)
      :start_stop_defrosting
      iex> C.command_name(0x06)
      :start_stop_ionising
      iex> length(C.properties)
      10
      iex> List.last(C.properties)
      {0x0A, :auto_hvac_profile}
  """

  @spec_file "specs/climate.json"
  @type command_type ::
          :get_climate_state
          | :climate_state
          | :set_climate_profile
          | :start_stop_hvac
          | :start_stop_defogging
          | :start_stop_defrosting
          | :start_stop_ionising

  @command_module AutoApi.ClimateCommand
  @state_module AutoApi.ClimateState

  use AutoApi.Capability
end
