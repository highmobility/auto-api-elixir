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

        iex> AutoApi.FuelingCommand.execute(%AutoApi.FuelingState{}, <<0x00>>)
        {:state, %AutoApi.FuelingState{}}

        iex> command = <<0x01>> <> <<0x01, 1::integer-16, 0x01>>
        iex> AutoApi.FuelingCommand.execute(%AutoApi.FuelingState{}, command)
        {:state_changed, %AutoApi.FuelingState{gas_flap: :opened}}

        iex> AutoApi.FuelingCommand.execute(%AutoApi.FuelingState{}, <<0x02>>)
        {:state_changed, %AutoApi.FuelingState{gas_flap: :open}}
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

  def execute(%FuelingState{} = state, <<0x02>>) do
    new_state = %{state | gas_flap: :open}

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts DoorLocksCommand state to capability's state in binary

        iex> AutoApi.FuelingCommand.state(%AutoApi.FuelingState{properties: [:gas_flap]})
        <<1, 1, 0, 1, 0>>
  """
  @spec state(FuelingState.t()) :: binary
  def state(%FuelingState{} = state) do
    <<0x01, FuelingState.to_bin(state)::binary>>
  end

  @doc """
  Returns binary command
      iex> AutoApi.FuelingCommand.to_bin(:get_gas_flap_state, [])
      <<0x00>>

      iex> AutoApi.FuelingCommand.to_bin(:open_gas_flap, [])
      <<2>>
  """
  @spec to_bin(FuelingCapability.command_type(), list(any)) :: binary
  def to_bin(:get_gas_flap_state, _args) do
    cmd_id = FuelingCapability.command_id(:get_gas_flap_state)
    <<cmd_id>>
  end

  def to_bin(:open_gas_flap, []) do
    cmd_id = FuelingCapability.command_id(:open_gas_flap)
    <<cmd_id>>
  end
end
