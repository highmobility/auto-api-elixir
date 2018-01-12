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
defmodule AutoApi.RooftopCommand do
  @moduledoc """
  Handles Rooftop commands and apply binary commands on %AutoApi.RooftopState{}
  """
  @behaviour AutoApi.Command

  alias AutoApi.RooftopState
  alias AutoApi.RooftopCapability
  @doc """
  Parses the binary command and makes changes or returns the state

        iex> AutoApi.RooftopCommand.execute(%AutoApi.RooftopState{}, <<0x00>>)
        {:state, %AutoApi.RooftopState{}}

        iex> AutoApi.RooftopCommand.execute(%AutoApi.RooftopState{}, <<0x02, 59, 100>>)
        {:state_changed, %AutoApi.RooftopState{dimming: 59, open: 100}}
  """
  def execute(%RooftopState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%RooftopState{} = state, <<0x02, new_values::binary-size(2)>>) do
    new_state = RooftopState.from_bin(new_values)
    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end


  @doc """
  Converts Rooftop state to capability's state in binary

        iex> AutoApi.RooftopCommand.state(%AutoApi.RooftopState{dimming: 59, open: 100})
        <<0x01, 0x3B, 0x64>>
  """
  def state(%RooftopState{} = state) do
    bin_state = RooftopState.to_bin(state)
    <<0x01, bin_state::binary>>
  end

  @doc """
  Converts Rooftop state to capability's vehicle state binary

      iex> AutoApi.RooftopCommand.vehicle_state(%AutoApi.RooftopState{dimming: 0, open: 100})
      <<0x02, 0x00, 0x64>>
  """
  def vehicle_state(%RooftopState{} = state) do
    resp_size = 0x02
    <<resp_size, state.dimming, state.open>>
  end

  @doc """
  Converts command to binary format

      iex> AutoApi.RooftopCommand.to_bin(:get_rooftop_state, [])
      <<0x00>>
  """
  @spec to_bin(RooftopCapability.command_type, list(any())) :: binary
  def to_bin(:get_rooftop_state, []) do
    cmd_id = RooftopCapability.command_id(:get_rooftop_state)
    <<cmd_id>>
  end
end
