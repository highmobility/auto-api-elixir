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
defmodule AutoApi.EngineCommand do
  @moduledoc """
  Handles  commands and apply binary commands on `%AutoApi.EngineState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.EngineState
  alias AutoApi.EngineCapability

  @doc """
  Parses the binary command and makes changes or returns the state

        iex> AutoApi.EngineCommand.execute(%AutoApi.EngineState{}, <<0x00>>)
        {:state, %AutoApi.EngineState{}}

        iex> command = <<0x01>> <> <<0x01, 1::integer-16, 0x01>> <> <<0x02, 1::integer-16, 0x00>>
        iex> AutoApi.EngineCommand.execute(%AutoApi.EngineState{}, command)
        {:state_changed, %AutoApi.EngineState{ignition: :engine_on, accessories_ignition: :powered_off}}

        iex> AutoApi.EngineCommand.execute(%AutoApi.EngineState{}, <<0x02, 0x00>>)
        {:state_changed, %AutoApi.EngineState{ignition: :engine_off}}

        iex> AutoApi.EngineCommand.execute(%AutoApi.EngineState{}, <<0x02, 0x01>>)
        {:state_changed, %AutoApi.EngineState{ignition: :engine_on}}

  """
  @spec execute(EngineState.t(), binary) :: {:state | :state_changed, EngineState.t()}
  def execute(%EngineState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%EngineState{} = state, <<0x01, ds::binary>>) do
    new_state = EngineState.from_bin(ds)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  def execute(%EngineState{} = state, <<0x02, engine_state>>) do
    new_state =
      if engine_state == 0x01 do
        %{state | ignition: :engine_on}
      else
        %{state | ignition: :engine_off}
      end

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts EngineCommand state to capability's state in binary

        iex> AutoApi.EngineCommand.state(%AutoApi.EngineState{ignition: :engine_off, properties: [:ignition]})
        <<1, 1, 0, 1, 0>>
  """
  @spec state(EngineState.t()) :: binary
  def state(%EngineState{} = state) do
    <<0x01, EngineState.to_bin(state)::binary>>
  end

  @doc """
  Returns binary command
      iex> AutoApi.EngineCommand.to_bin(:get_ignition_state, [])
      <<0x00>>

      iex> AutoApi.EngineCommand.to_bin(:turn_engine_on_off, [:on])
      <<2, 0x01>>

      iex> AutoApi.EngineCommand.to_bin(:turn_engine_on_off, [:off])
      <<2, 0x00>>

  """
  @spec to_bin(EngineCapability.command_type(), list(any)) :: binary
  def to_bin(:get_ignition_state = msg, []) do
    cmd_id = EngineCapability.command_id(msg)
    <<cmd_id>>
  end

  def to_bin(:turn_engine_on_off = msg, [:on]) do
    cmd_id = EngineCapability.command_id(msg)
    <<cmd_id, 0x01>>
  end

  def to_bin(:turn_engine_on_off = msg, [:off]) do
    cmd_id = EngineCapability.command_id(msg)
    <<cmd_id, 0x00>>
  end
end
