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
defmodule AutoApi.HomeChargerCapability do
  @moduledoc """
  Basic settings for HomeCharger Capability

      iex> alias AutoApi.HomeChargerCapability, as: H
      iex> H.identifier
      <<0x00, 0x60>>
      iex> H.name
      :home_charger
      iex> H.description
      "Home Charger"
      iex> length(H.properties)
      15
      iex> List.last(H.properties)
      {0x12, :price_tariffs}
  """

  @spec_file "specs/home_charger.json"
  @type command_type ::
          :get_home_charger_state
          | :home_charger_state
          | :set_charge_current
          | :set_price_tariffs
          | :activate_deactivate_solar_charging
          | :enable_disable_wi_fi_hotspot
          | :authenticate_expire

  @command_module AutoApi.NotImplemented
  @state_module AutoApi.HomeChargerState

  use AutoApi.Capability
end
