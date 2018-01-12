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
defmodule AutoApi.ChargeState do
  alias AutoApi.CommonData

  alias __MODULE__
  @start_charging_cmd 0x00
  @stop_charging_cmd 0x01

  defstruct charging_state: nil, estimated_range: nil,
    battery_level: nil, battery_current: nil,
    charger_voltage: nil, charge_limit: nil,
    charge_in: nil, charging_rate: nil, charge_port: nil

  use AutoApi.State
  @type charging_state_type :: :disconnected | :plugged_in | :charging | :completed

  @type t :: %ChargeState{
	charging_state: charging_state_type, estimated_range: integer,
	battery_level: integer, battery_current: float,
	charger_voltage: integer, charge_limit: integer,
	charge_in: integer, charging_rate: float, charge_port: CommonData.position
  }

  @spec from_bin(<<_::144>>) :: t
  def from_bin(
    <<charging, estimated_range::integer-16, battery_level, battery_current::float-32,
    charger_voltage::integer-16, charge_limit,
    charge_in::integer-16, charging_rate::float-32, charge_port>>) do
      %__MODULE__{
        charging_state: bin_charging_to_atom(charging), estimated_range: estimated_range,
        battery_level: battery_level, battery_current: battery_current,
        charger_voltage: charger_voltage, charge_limit: charge_limit,
        charge_in: charge_in, charging_rate: charging_rate,
        charge_port: CommonData.bin_position_to_atom(charge_port)
      }
  end

  @spec to_bin(t) :: binary
  def to_bin(%ChargeState{} = state) do
    <<atom_charging_to_bin(state.charging_state), state.estimated_range::integer-16, state.battery_level, state.battery_current::float-32,
    state.charger_voltage::integer-16, state.charge_limit,
    state.charge_in::integer-16, state.charging_rate::float-32, CommonData.atom_position_to_bin(state.charge_port)>>
  end

  @spec to_vehicle_state_bin(t) :: binary
  def to_vehicle_state_bin(%ChargeState{} = state) do
    <<atom_charging_to_bin(state.charging_state), state.estimated_range::integer-16,
      state.battery_level, state.battery_current::float-32>>
  end

  def change_charging_state(%__MODULE__{charging_state: :plugged_in} = state, @start_charging_cmd) do
    %{state | charging_state: :charging}
  end

  def change_charging_state(%__MODULE__{charging_state: charging_state} = state, @stop_charging_cmd) when charging_state not in [:disconnected] do
    %{state | charging_state: :plugged_in}
  end
  def change_charging_state(state, _) do
    state
  end

  defp bin_charging_to_atom(0x0), do: :disconnected
  defp bin_charging_to_atom(0x1), do: :plugged_in
  defp bin_charging_to_atom(0x2), do: :charging
  defp bin_charging_to_atom(0x3), do: :completed

  defp atom_charging_to_bin(:disconnected), do: 0x01
  defp atom_charging_to_bin(:plugged_in), do: :plugged_in
  defp atom_charging_to_bin(:charging), do: 0x02
  defp atom_charging_to_bin(:completed), do: 0x03
end
