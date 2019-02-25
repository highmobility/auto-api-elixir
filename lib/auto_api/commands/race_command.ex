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
defmodule AutoApi.RaceCommand do
  @moduledoc """
  Handles Race commands and apply binary commands on `%AutoApi.RaceState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.RaceState
  alias AutoApi.RaceCapability

  @doc """
  Parses the binary command and makes changes or returns the state
  """
  @spec execute(RaceState.t(), binary) :: {:state | :state_changed, RaceState.t()}
  def execute(%RaceState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%RaceState{} = state, <<0x01, ds::binary>>) do
    new_state = RaceState.from_bin(ds)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts RaceCommand state to capability's state in binary
  """
  @spec state(RaceState.t()) :: binary
  def state(%RaceState{} = state) do
    <<0x01, RaceState.to_bin(state)::binary>>
  end

  @doc """
  Converts command to binary format
  """
  @spec to_bin(RaceCapability.command_type(), list(any())) :: binary
  def to_bin(:get_race_state, []) do
    cmd_id = RaceCapability.command_id(:get_race_state)
    <<cmd_id>>
  end
end
