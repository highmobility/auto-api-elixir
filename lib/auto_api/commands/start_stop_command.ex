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
defmodule AutoApi.StartStopCommand do
  @moduledoc """
  Handles  commands and apply binary commands on `%AutoApi.StartStopState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.StartStopState
  alias AutoApi.StartStopCapability

  @doc """
  Parses the binary command and makes changes or returns the state

        iex> AutoApi.StartStopCommand.execute(%AutoApi.StartStopState{}, <<0x00>>)
        {:state, %AutoApi.StartStopState{}}

        iex> command = <<0x01>> <> <<0x01, 1::integer-16, 0x01>>
        iex> AutoApi.StartStopCommand.execute(%AutoApi.StartStopState{}, command)
        {:state_changed, %AutoApi.StartStopState{start_stop: :active}}

        iex> AutoApi.StartStopCommand.execute(%AutoApi.StartStopState{}, <<0x02>>)
        {:state_changed, %AutoApi.StartStopState{start_stop: :active}}

        iex> AutoApi.StartStopCommand.execute(%AutoApi.StartStopState{start_stop: :active}, <<0x02>>)
        {:state_changed, %AutoApi.StartStopState{start_stop: :inactive}}

  """
  @spec execute(StartStopState.t(), binary) :: {:state | :state_changed, StartStopState.t()}
  def execute(%StartStopState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%StartStopState{} = state, <<0x01, ds::binary>>) do
    new_state = StartStopState.from_bin(ds)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  def execute(%StartStopState{} = state, <<0x02>>) do
    new_value = if(state.start_stop == :active, do: :inactive, else: :active)
    new_state = %{state | start_stop: new_value}

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts DoorLocksCommand state to capability's state in binary

        iex> AutoApi.StartStopCommand.state(%AutoApi.StartStopState{properties: [:start_stop]})
        <<1, 1, 0, 1, 0>>
  """
  @spec state(StartStopState.t()) :: binary
  def state(%StartStopState{} = state) do
    <<0x01, StartStopState.to_bin(state)::binary>>
  end

  @doc """
  Returns binary command
      iex> AutoApi.StartStopCommand.to_bin(:get_start_stop_state, [])
      <<0x00>>

      iex> AutoApi.StartStopCommand.to_bin(:activate_deactivate_start_stop, [])
      <<2>>
  """
  @spec to_bin(StartStopCapability.command_type(), list(any)) :: binary
  def to_bin(:get_start_stop_state = msg, _args) do
    cmd_id = StartStopCapability.command_id(msg)
    <<cmd_id>>
  end

  def to_bin(:activate_deactivate_start_stop = msg, []) do
    cmd_id = StartStopCapability.command_id(msg)
    <<cmd_id>>
  end
end
