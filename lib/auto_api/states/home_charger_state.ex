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
defmodule AutoApi.HomeChargerState do
  @moduledoc """
  HomeCharger state
  """

  alias AutoApi.{CommonData, PropertyComponent}

  defstruct charging: nil,
            authentication_mechanism: nil,
            plug_type: nil,
            charging_power: nil,
            solar_charging: nil,
            hotspot_enabled: nil,
            hotspot_ssid: nil,
            wi_fi_hotspot_security: nil,
            wi_fi_hotspot_password: nil,
            authentication_state: nil,
            charge_current_dc: nil,
            maximum_charge_current: nil,
            minimum_charge_current: nil,
            coordinates: nil,
            price_tariffs: [],
            timestamp: nil,
            properties: [],
            property_timestamps: %{}

  use AutoApi.State, spec_file: "specs/home_charger.json"

  @type charging :: :disconnected | :plugged_in | :charging
  @type authentication_mechanism :: :pin | :app
  @type plug_type :: :type_1 | :type_2 | :ccs | :chademo
  @type enabled :: :enabled | :disabled
  @type authentication_state :: :authenticated | :unauthenticated
  @type pricing_type :: :starting_fee | :per_minute | :per_kwh
  @type price_tariff :: %PropertyComponent{
          data: %{
            currency: String.t(),
            currency_size: integer,
            price: float,
            pricing_type: pricing_type
          }
        }

  @type t :: %__MODULE__{
          charging: %PropertyComponent{data: charging} | nil,
          authentication_mechanism: %PropertyComponent{data: authentication_mechanism} | nil,
          plug_type: %PropertyComponent{data: plug_type} | nil,
          charging_power: %PropertyComponent{data: float} | nil,
          solar_charging: %PropertyComponent{data: CommonData.activity_switched()} | nil,
          hotspot_enabled: %PropertyComponent{data: enabled} | nil,
          hotspot_ssid: %PropertyComponent{data: String.t()} | nil,
          wi_fi_hotspot_security: %PropertyComponent{data: CommonData.network_security()} | nil,
          wi_fi_hotspot_password: %PropertyComponent{data: String.t()} | nil,
          authentication_state: %PropertyComponent{data: authentication_state} | nil,
          charge_current_dc: %PropertyComponent{data: float} | nil,
          maximum_charge_current: %PropertyComponent{data: float} | nil,
          minimum_charge_current: %PropertyComponent{data: float} | nil,
          coordinates: %PropertyComponent{data: CommonData.coordinates()} | nil,
          price_tariffs: list(price_tariff),
          timestamp: DateTime.t() | nil,
          properties: list(atom),
          property_timestamps: map()
        }

  @doc """
  Build state based on binary value

    iex> AutoApi.HomeChargerState.from_bin(<<1, 4::integer-16, 1, 0, 1, 1>>)
    %AutoApi.HomeChargerState{charging: %AutoApi.PropertyComponent{data: :plugged_in}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.HomeChargerState{charging: %AutoApi.PropertyComponent{data: :plugged_in}, properties: [:charging]}
    iex> AutoApi.HomeChargerState.to_bin(state)
    <<1, 4::integer-16, 1, 0, 1, 1>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
