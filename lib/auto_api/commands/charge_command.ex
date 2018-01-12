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
defmodule AutoApi.ChargeCommand do
  @moduledoc """
  Handles Engine commands and apply binary commands on `%AutoApi.ChargeState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.ChargeState
  alias AutoApi.ChargeCapability
  @doc """
  Parses the binary command and makes changes or returns the state

        iex> AutoApi.ChargeCommand.execute(%AutoApi.ChargeState{charging_state: :completed}, <<0x00>>)
        {:state, %AutoApi.ChargeState{charging_state: :completed}}

        iex> charge_state_bin = <<0x1, 0x2, 0x00, 0xFF, 0x32, -1.0::float-32, 0x01, 0x90, 0x5A, 0x00, 0x3C, 0.0::float-32, 0x01>>
        iex> AutoApi.ChargeCommand.execute(%AutoApi.ChargeState{}, charge_state_bin)
        {:state_changed, %AutoApi.ChargeState{charging_state: :charging, estimated_range: 255, battery_level: 50, battery_current: -1.0, charger_voltage: 400, charge_limit: 90, charge_in: 60, charging_rate: 0.0, charge_port: :open}}

        iex> {:state_changed, new_state} = AutoApi.ChargeCommand.execute(%AutoApi.ChargeState{charging_state: :plugged_in}, <<0x02, 0x00>>)
        {:state_changed, %AutoApi.ChargeState{charging_state: :charging}}
        iex> AutoApi.ChargeCommand.execute(new_state, <<0x02, 0x01>>)
        {:state_changed, %AutoApi.ChargeState{charging_state: :plugged_in}}

        iex> AutoApi.ChargeCommand.execute(%AutoApi.ChargeState{charging_state: :disconnected}, <<0x02, 0x00>>)
        {:state, %AutoApi.ChargeState{charging_state: :disconnected}}


  """
  @spec execute(ChargeState.t, binary) :: {:state|:state_changed, ChargeState.t}
  def execute(%ChargeState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%ChargeState{} = state, <<0x01, charging_state::binary>>) do
    new_state = ChargeState.from_bin(charging_state)
    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  def execute(%ChargeState{} = state, <<0x02, charging_cmd>>) do
    charge_state = ChargeState.change_charging_state(state, charging_cmd)
    if charge_state == state do
      {:state, state}
    else
      {:state_changed, charge_state}
    end
  end

  @doc """
  Converts VehicleLocation state to capability's state in binary

        iex> state = %AutoApi.ChargeState{charging_state: :charging, estimated_range: 255, battery_level: 50, battery_current: -1.0, charger_voltage: 400, charge_limit: 90, charge_in: 60, charging_rate: 0.0, charge_port: :open}
        iex> AutoApi.ChargeCommand.state(state)
        <<0x1, 0x2, 0x00, 0xFF, 0x32, -1.0::float-32, 0x01, 0x90, 0x5A, 0x00, 0x3C, 0.0::float-32, 0x01>>
  """
  @spec state(ChargeState.t) :: <<_::168>>
  def state(%ChargeState{} = state) do
    <<0x01, ChargeState.to_bin(state)::binary>>
  end

  @doc """
  Converts VehicleLocation state to capability's vehicle state binary

        iex> state = %AutoApi.ChargeState{charging_state: :charging, estimated_range: 255, battery_level: 50, battery_current: -1.0, charger_voltage: 400, charge_limit: 90, charge_in: 60, charging_rate: 0.0, charge_port: :open}
        iex> AutoApi.ChargeCommand.vehicle_state(state)
        <<0x08, 0x02, 255::integer-16, 50, -1.0::float-32>>
  """
  @spec vehicle_state(ChargeState.t) :: <<_::88>>
  def vehicle_state(%ChargeState{} = state) do
    <<0x08, ChargeState.to_vehicle_state_bin(state)::binary>>
  end

  @doc """
  Converts command to binary format

      iex> AutoApi.ChargeCommand.to_bin(:get_charge_state, [])
      <<0x00>>
  """
  @spec to_bin(ChargeCapability.command_type, list(any())) :: binary
  def to_bin(:get_charge_state, []) do
    cmd_id = ChargeCapability.command_id(:get_charge_state)
    <<cmd_id>>
  end
end
