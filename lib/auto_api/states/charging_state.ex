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
defmodule AutoApi.ChargingState do
  @moduledoc """
  Keeps Charging state
  """

  @type charging :: :disconnected | :plugged_in | :charging | :charging_complete
  @type charge_port_state :: :closed | :open
  @type charge_mode :: :immediate | :timer_based | :inductive
  @type timer_type :: :preferred_start_time | :preferred_end_time | :departure_time
  @type charge_timer :: %{
          timer_type: timer_type,
          year: integer,
          month: integer,
          day: integer,
          minute: integer,
          second: integer,
          utc_time_offset: integer
        }

  @doc """
  Charging state
  """
  defstruct charging: :disconnected,
            estimated_range: 0,
            battery_level: 0,
            battery_current_ac: 0.0,
            battery_current_dc: 0.0,
            charger_voltage_ac: 0.0,
            charger_voltage_dc: 0.0,
            charge_limit: 0,
            time_to_complete_charge: 0,
            charging_rate_kw: 0.0,
            charge_port_state: :closed,
            charge_mode: :timer_based,
            charge_timer: [],
            properties: []

  use AutoApi.State, spec_file: "specs/charging.json"

  @type t :: %__MODULE__{
          charging: charging,
          estimated_range: integer,
          battery_level: integer,
          battery_current_ac: float,
          battery_current_dc: float,
          charger_voltage_ac: float,
          charger_voltage_dc: float,
          charge_limit: integer,
          time_to_complete_charge: integer,
          charging_rate_kw: float,
          charge_port_state: charge_port_state,
          charge_mode: charge_mode,
          charge_timer: list(charge_timer),
          properties: list(atom)
        }

  @doc """
  Build state based on binary value

    iex> AutoApi.ChargingState.from_bin(<<0x01, 1::integer-16, 0x01>>)
    %AutoApi.ChargingState{charging: :plugged_in}

    iex> AutoApi.ChargingState.from_bin(<<0x01, 1::integer-16, 0x03, 0x0A, 4::integer-16, 99.1::float-32>>)
    %AutoApi.ChargingState{charging: :charging_complete, charging_rate_kw: 99.1}

    iex> AutoApi.ChargingState.from_bin(<<0x0D, 9::integer-16, 0x02, 0x12, 0x01, 0x0A, 0x10, 0x20, 0x05, 0x00, 0x00>>)
    %AutoApi.ChargingState{charge_timer: [%{day: 10, hour: 16, minute: 32, month: 1, second: 5, timer_type: :departure_time, utc_time_offset: 0, year: 18}]}

  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> properties = [:charging, :charging_rate_kw]
    iex> AutoApi.ChargingState.to_bin(%AutoApi.ChargingState{charging: :charging_complete, charging_rate_kw: 99.1, properties: properties})
    <<0x01, 1::integer-16, 0x03, 0x0A, 4::integer-16, 99.1::float-32>>

    iex> properties = AutoApi.ChargingCapability.properties |> Enum.into(%{}) |> Map.values()
    iex> AutoApi.ChargingState.to_bin(%AutoApi.ChargingState{properties: properties})
    <<4, 0, 4, 0, 0, 0, 0, 5, 0, 4, 0, 0, 0, 0, 3, 0, 1, 0, 8, 0, 1, 0, 12, 0, 1, 1,\
      11, 0, 1, 0, 6, 0, 4, 0, 0, 0, 0, 7, 0, 4, 0, 0, 0, 0, 1, 0, 1, 0, 10, 0, 4, \
      0, 0, 0, 0, 2, 0, 2, 0, 0, 9, 0, 2, 0, 0>>

    iex> charge_timer = [%{day: 10, hour: 16, minute: 32, month: 1, second: 5, timer_type: :departure_time, utc_time_offset: 0, year: 18}]
    iex> AutoApi.ChargingState.to_bin(%AutoApi.ChargingState{charge_timer: charge_timer, properties: [:charge_timer]})
    <<0x0D, 9::integer-16, 0x02, 0x12, 0x01, 0x0A, 0x10, 0x20, 0x05, 0x00, 0x00>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end