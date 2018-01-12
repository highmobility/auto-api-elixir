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
defmodule AutoApi.TrunkAccessCommand do
  @moduledoc """
  Handles TrunkAccess commands and apply binary commands on `%AutoApi.TrunkAccessState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.TrunkAccessState
  alias AutoApi.TrunkAccessCapability
  @doc """
  Parses the binary command and makes changes or returns the state

        iex> AutoApi.TrunkAccessCommand.execute(%AutoApi.TrunkAccessState{lock: :locked, position: :open}, <<0x00>>)
        {:state, %AutoApi.TrunkAccessState{lock: :locked, position: :open}}

        iex> AutoApi.TrunkAccessCommand.execute(%AutoApi.TrunkAccessState{}, <<0x01, 0x01, 0x00>>)
        {:state_changed, %AutoApi.TrunkAccessState{lock: :locked, position: :closed}}

        iex> AutoApi.TrunkAccessCommand.execute(%AutoApi.TrunkAccessState{}, <<0x02, 0x00, 0x01>>)
        {:state_changed, %AutoApi.TrunkAccessState{lock: :unlocked, position: :open}}

        iex> AutoApi.TrunkAccessCommand.execute(%AutoApi.TrunkAccessState{}, <<0x02, 0x01, 0x00>>)
        {:state_changed, %AutoApi.TrunkAccessState{lock: :locked, position: :closed}}

  """
  @spec execute(TrunkAccessState.t, binary) :: {:state|:state_changed, TrunkAccessState.t}
  def execute(%TrunkAccessState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%TrunkAccessState{} = state, <<0x01, trunk_state::binary-size(2)>>) do
    new_state = TrunkAccessState.from_bin(trunk_state)
    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  def execute(%TrunkAccessState{} = state, <<0x02, new_trunk_state::binary-size(2)>>) do
    new_state = TrunkAccessState.from_bin(new_trunk_state)
    {:state_changed, %{state | lock: new_state.lock, position: new_state.position}}
  end

  @doc """
  Converts TrunkAccess state to capability's state in binary

        iex> AutoApi.TrunkAccessCommand.state(%AutoApi.TrunkAccessState{lock: :locked, position: :open})
        <<0x1, 0x01, 0x01>>
  """
  @spec state(TrunkAccessState.t) :: <<_::40>>
  def state(%TrunkAccessState{} = state) do
    <<0x01, TrunkAccessState.to_bin(state)::binary-size(2)>>
  end

  @doc """
  Converts TrunkAccess state to capability's vehicle state binary

        iex> AutoApi.TrunkAccessCommand.vehicle_state(%AutoApi.TrunkAccessState{lock: :unlocked, position: :closed})
        <<0x02, 0x00, 0x00>>
  """
  @spec vehicle_state(TrunkAccessState.t) :: <<_::40>>
  def vehicle_state(%TrunkAccessState{} = state) do
    <<0x02, TrunkAccessState.to_bin(state)::binary-size(2)>>
  end

  @doc """
  Converts command to binary format

      iex> AutoApi.TrunkAccessCommand.to_bin(:get_trunk_state, [])
      <<0x00>>
  """
  @spec to_bin(TrunkAccessCapability.command_type, list(any())) :: binary
  def to_bin(:get_trunk_state, []) do
    cmd_id = TrunkAccessCapability.command_id(:get_trunk_state)
    <<cmd_id>>
  end
end
