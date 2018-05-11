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
defmodule AutoApi.TachographCommand do
  @moduledoc """
  Handles Tachograph commands and apply binary commands on `%AutoApi.TachographState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.TachographState
  alias AutoApi.TachographCapability

  @doc """
  Parses the binary command and makes changes or returns the state

        iex> AutoApi.TachographCommand.execute(%AutoApi.TachographState{}, <<0x00>>)
        {:state, %AutoApi.TachographState{}}

        iex> command = <<0x01>> <> <<0x07, 2::integer-16, 53::integer-16, 0x05, 1::integer-16, 0x01>>
        iex> AutoApi.TachographCommand.execute(%AutoApi.TachographState{}, command)
        {:state_changed, %AutoApi.TachographState{vehicle_speed: 53, vehicle_overspeed: :overspeed}}

  """
  @spec execute(TachographState.t(), binary) :: {:state | :state_changed, TachographState.t()}
  def execute(%TachographState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%TachographState{} = state, <<0x01, ds::binary>>) do
    new_state = TachographState.from_bin(ds)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts TachographCommand state to capability's state in binary

        iex> properties = [:vehicle_speed, :vehicle_direction, :vehicle_overspeed, :vehicle_motion]
        iex> AutoApi.TachographCommand.state(%AutoApi.TachographState{vehicle_speed: 1, vehicle_direction: :reverse, properties: properties})
        <<1, 6, 0, 1, 1, 4, 0, 1, 0, 5, 0, 1, 0, 7, 0, 2, 0, 1>>

        iex> properties = AutoApi.TachographCapability.properties |> Enum.into(%{}) |> Map.values()
        iex> AutoApi.TachographCommand.state(%AutoApi.TachographState{properties: properties})
        <<0x1, 0x6, 0x0, 0x1, 0x0, 0x4, 0x0, 0x1, 0x0, 0x5, 0x0, 0x1, 0x0, 0x7, 0x0, 0x2, 0x0, 0x0>>
  """
  @spec state(TachographState.t()) :: binary
  def state(%TachographState{} = state) do
    <<0x01, TachographState.to_bin(state)::binary>>
  end

  @doc """
  Converts command to binary format

      iex> AutoApi.TachographCommand.to_bin(:get_tachograph_state, [])
      <<0x00>>
  """
  @spec to_bin(TachographCapability.command_type(), list(any())) :: binary
  def to_bin(:get_tachograph_state, []) do
    cmd_id = TachographCapability.command_id(:get_tachograph_state)
    <<cmd_id>>
  end
end
