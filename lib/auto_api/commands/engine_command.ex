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
  Handles Engine commands and apply binary commands on `%AutoApi.EngineState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.EngineState
  alias AutoApi.EngineCapability
  @doc """
  Parses the binary command and makes changes or returns the state

        iex> AutoApi.EngineCommand.execute(%AutoApi.EngineState{engine: :off}, <<0x00>>)
        {:state, %AutoApi.EngineState{engine: :off}}

        iex> AutoApi.EngineCommand.execute(%AutoApi.EngineState{}, <<0x01, 0x01>>)
        {:state_changed, %AutoApi.EngineState{engine: :on}}

        iex> AutoApi.EngineCommand.execute(%AutoApi.EngineState{}, <<0x01, 0x00>>)
        {:state_changed, %AutoApi.EngineState{engine: :off}}

        iex> AutoApi.EngineCommand.execute(%AutoApi.EngineState{engine: :on}, <<0x02, 0x00>>)
        {:state_changed, %AutoApi.EngineState{engine: :off}}

  """
  @spec execute(EngineState.t, binary) :: {:state|:state_changed, EngineState.t}
  def execute(%EngineState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%EngineState{} = state, <<0x01, engine_status>>) do
    new_state = EngineState.from_bin(engine_status)
    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  def execute(%EngineState{} = state, <<0x02, new_engine_status>>) do
    new_state = EngineState.from_bin(new_engine_status)
    {:state_changed, %{state | engine: new_state.engine}}
  end

  @doc """
  Converts VehicleLocation state to capability's state in binary

        iex> AutoApi.EngineCommand.state(%AutoApi.EngineState{engine: :on})
        <<0x1, 0x01>>
  """
  @spec state(EngineState.t) :: <<_::32>>
  def state(%EngineState{} = state) do
    <<0x01, EngineState.to_bin(state)>>
  end

  @doc """
  Converts VehicleLocation state to capability's vehicle state binary

      iex> AutoApi.EngineCommand.state(%AutoApi.EngineState{engine: :off})
      <<0x01, 0x00>>
  """
  @spec vehicle_state(EngineState.t) :: <<_::32>>
  def vehicle_state(%EngineState{} = state) do
    <<0x01, EngineState.to_bin(state)>>
  end

  @doc """
  Converts command to binary format

      iex> AutoApi.EngineCommand.to_bin(:get_ignition_state, [])
      <<0x00>>
  """
  @spec to_bin(EngineCapability.command_type, list(any())) :: binary
  def to_bin(:get_ignition_state, []) do
    cmd_id = EngineCapability.command_id(:get_ignition_state)
    <<cmd_id>>
  end
end
