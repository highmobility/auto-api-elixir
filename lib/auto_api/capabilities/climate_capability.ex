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
      iex> length(C.properties)
      11
      iex> List.last(C.properties)
      {0x0C, :rear_temperature_setting}
  """

  @type command_type ::
          :get_climate_state
          | :climate_state
          | :change_starting_times
          | :start_stop_hvac
          | :start_stop_defogging
          | :start_stop_defrosting
          | :start_stop_ionising
          | :set_temperature_settings

  @command_module AutoApi.ClimateCommand
  @state_module AutoApi.ClimateState

  use AutoApi.Capability, spec_file: "specs/climate.json"
end
