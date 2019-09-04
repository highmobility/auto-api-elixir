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
defmodule AutoApi.WeatherConditionsCapability do
  @moduledoc """
  Basic settings for WeatherConditions Capability

      iex> alias AutoApi.WeatherConditionsCapability, as: W
      iex> W.identifier
      <<0x00, 0x55>>
      iex> W.name
      :weather_conditions
      iex> W.description
      "Weather Conditions"
      iex> length(W.properties)
      1
      iex> W.properties
      [{1, :rain_intensity}]
  """

  @type command_type ::
          :get_wi_fi_state
          | :wi_fi_state
          | :connect_to_network
          | :forget_network
          | :enable_disable_wi_fi

  @command_module AutoApi.NotImplemented
  @state_module AutoApi.WeatherConditionsState

  use AutoApi.Capability, spec_file: "specs/weather_conditions.json"
end
