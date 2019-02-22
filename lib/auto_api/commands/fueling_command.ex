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
defmodule AutoApi.FuelingCommand do
  @moduledoc """
  Handles  commands and apply binary commands on `%AutoApi.FuelingState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.FuelingState
  alias AutoApi.FuelingCapability

  @doc """
  Parses the binary command and makes changes or returns the state
  """
  @spec execute(FuelingState.t(), binary) :: {:state | :state_changed, FuelingState.t()}
  def execute(%FuelingState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%FuelingState{} = state, <<0x01, ds::binary>>) do
    new_state = FuelingState.from_bin(ds)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts DoorLocksCommand state to capability's state in binary
  """
  @spec state(FuelingState.t()) :: binary
  def state(%FuelingState{} = state) do
    <<0x01, FuelingState.to_bin(state)::binary>>
  end

  @doc """
  Returns binary command
  """
  @spec to_bin(FuelingCapability.command_type(), list(any)) :: binary
  def to_bin(:get_gas_flap_state, _args) do
    cmd_id = FuelingCapability.command_id(:get_gas_flap_state)
    <<cmd_id>>
  end

  def to_bin(:control_gas_flap = cmd, gas_flap_position: state) do
    cmd_id = FuelingCapability.command_id(cmd)
    gas_flap_value = if state == :close, do: 0x00, else: 0x01
    <<cmd_id, 0x01, gas_flap_value>>
  end
end
