# AutoAPI
# The MIT License
#
# Copyright (c) 2018- High-Mobility GmbH (https://high-mobility.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
defmodule AutoApiL12.HomeChargerState do
  @moduledoc """
  HomeCharger state
  """

  alias AutoApiL12.{CommonData, State, UnitType}

  use AutoApiL12.State, spec_file: "home_charger.json"

  @type charging_status :: :disconnected | :plugged_in | :charging
  @type authentication_mechanism :: :pin | :app
  @type plug_type :: :type_1 | :type_2 | :ccs | :chademo
  @type authentication_state :: :authenticated | :unauthenticated
  @type pricing_type :: :starting_fee | :per_minute | :per_kwh
  @type price_tariff :: %{
          currency: String.t(),
          price: float,
          pricing_type: pricing_type
        }

  @type t :: %__MODULE__{
          charging_status: State.property(charging_status),
          authentication_mechanism: State.property(authentication_mechanism),
          plug_type: State.property(plug_type),
          # Deprecated
          charging_power_kw: State.property(UnitType.power()),
          solar_charging: State.property(CommonData.activity()),
          wi_fi_hotspot_enabled: State.property(CommonData.enabled_state()),
          wi_fi_hotspot_ssid: State.property(String.t()),
          wi_fi_hotspot_security: State.property(CommonData.network_security()),
          wi_fi_hotspot_password: State.property(String.t()),
          authentication_state: State.property(authentication_state),
          charge_current: State.property(UnitType.electric_current()),
          maximum_charge_current: State.property(UnitType.electric_current()),
          minimum_charge_current: State.property(UnitType.electric_current()),
          coordinates: State.property(CommonData.coordinates()),
          price_tariffs: State.multiple_property(price_tariff),
          charging_power: State.property(UnitType.power())
        }

  @doc """
  Build state based on binary value

    iex> AutoApiL12.HomeChargerState.from_bin(<<1, 4::integer-16, 1, 0, 1, 1>>)
    %AutoApiL12.HomeChargerState{charging_status: %AutoApiL12.Property{data: :plugged_in}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApiL12.HomeChargerState{charging_status: %AutoApiL12.Property{data: :plugged_in}}
    iex> AutoApiL12.HomeChargerState.to_bin(state)
    <<1, 4::integer-16, 1, 0, 1, 1>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
