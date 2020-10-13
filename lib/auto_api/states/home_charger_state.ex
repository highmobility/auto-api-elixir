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
defmodule AutoApi.HomeChargerState do
  @moduledoc """
  HomeCharger state
  """

  alias AutoApi.{CommonData, PropertyComponent}

  use AutoApi.State, spec_file: "home_charger.json"

  @type charging_status :: :disconnected | :plugged_in | :charging
  @type authentication_mechanism :: :pin | :app
  @type plug_type :: :type_1 | :type_2 | :ccs | :chademo
  @type enabled :: :enabled | :disabled
  @type authentication_state :: :authenticated | :unauthenticated
  @type pricing_type :: :starting_fee | :per_minute | :per_kwh
  @type price_tariff :: %PropertyComponent{
          data: %{
            currency: String.t(),
            price: float,
            pricing_type: pricing_type
          }
        }

  @type t :: %__MODULE__{
          charging_status: %PropertyComponent{data: charging_status} | nil,
          authentication_mechanism: %PropertyComponent{data: authentication_mechanism} | nil,
          plug_type: %PropertyComponent{data: plug_type} | nil,
          charging_power_kw: %PropertyComponent{data: float} | nil,
          solar_charging: %PropertyComponent{data: CommonData.activity()} | nil,
          wi_fi_hotspot_enabled: %PropertyComponent{data: enabled} | nil,
          wi_fi_hotspot_ssid: %PropertyComponent{data: String.t()} | nil,
          wi_fi_hotspot_security: %PropertyComponent{data: CommonData.network_security()} | nil,
          wi_fi_hotspot_password: %PropertyComponent{data: String.t()} | nil,
          authentication_state: %PropertyComponent{data: authentication_state} | nil,
          maximum_charge_current: %PropertyComponent{data: float} | nil,
          minimum_charge_current: %PropertyComponent{data: float} | nil,
          coordinates: %PropertyComponent{data: CommonData.coordinates()} | nil,
          price_tariffs: list(price_tariff)
        }

  @doc """
  Build state based on binary value

    iex> AutoApi.HomeChargerState.from_bin(<<1, 4::integer-16, 1, 0, 1, 1>>)
    %AutoApi.HomeChargerState{charging_status: %AutoApi.PropertyComponent{data: :plugged_in}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.HomeChargerState{charging_status: %AutoApi.PropertyComponent{data: :plugged_in}}
    iex> AutoApi.HomeChargerState.to_bin(state)
    <<1, 4::integer-16, 1, 0, 1, 1>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
