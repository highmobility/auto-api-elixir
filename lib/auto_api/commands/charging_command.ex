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
defmodule AutoApi.ChargingCommand do
  @moduledoc """
  Handles Charging commands and apply binary commands on `%AutoApi.ChargingState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.ChargingState
  alias AutoApi.ChargingCapability

  @doc """
  Parses the binary command and makes changes or returns the state
  """
  @spec execute(ChargingState.t(), binary) :: {:state | :state_changed, ChargingState.t()}
  def execute(%ChargingState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%ChargingState{} = state, <<0x01, ds::binary>>) do
    new_state = ChargingState.from_bin(ds)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  def execute(%ChargingState{} = state, <<0x12, _::binary>>) do
    {:state_changed, state}
  end

  @doc """
  Converts ChargingCommand state to capability's state in binary
  """
  @spec state(ChargingState.t()) :: binary
  def state(%ChargingState{} = state) do
    <<0x01, ChargingState.to_bin(state)::binary>>
  end

  @doc """
  Converts command to binary format
  """
  @spec to_bin(ChargingCapability.command_type(), list(any())) :: binary
  def to_bin(:get_charge_state, []) do
    cmd_id = ChargingCapability.command_id(:get_charge_state)
    <<cmd_id>>
  end
end
