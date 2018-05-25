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
defmodule AutoApi.ClimateCommand do
  @moduledoc """
  Handles  commands and apply binary commands on `%AutoApi.ClimateState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.ClimateState
  alias AutoApi.ClimateCapability

  @doc """
  Parses the binary command and makes changes or returns the state

        iex> AutoApi.ClimateCommand.execute(%AutoApi.ClimateState{}, <<0x00>>)
        {:state, %AutoApi.ClimateState{}}

        iex> command = <<0x01>> <> <<0x01, 4::integer-16, -1::float-32>>
        iex> AutoApi.ClimateCommand.execute(%AutoApi.ClimateState{}, command)
        {:state_changed, %AutoApi.ClimateState{inside_temperature: -1.0}}
  """
  @spec execute(ClimateState.t(), binary) :: {:state | :state_changed, ClimateState.t()}
  def execute(%ClimateState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%ClimateState{} = state, <<0x01, ds::binary>>) do
    new_state = ClimateState.from_bin(ds)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts ClimateCommand state to capability's state in binary

        iex> AutoApi.ClimateCommand.state(%AutoApi.ClimateState{inside_temperature: -20.0, properties: [:inside_temperature]})
        <<1, 1, 0, 4, -20.0::float-32>>
  """
  @spec state(ClimateState.t()) :: binary
  def state(%ClimateState{} = state) do
    <<0x01, ClimateState.to_bin(state)::binary>>
  end

  @doc """
  Returns binary command
      iex> AutoApi.ClimateCommand.to_bin(:get_climate_state, [])
      <<0x00>>
  """
  @spec to_bin(ClimateCapability.command_type(), list(any)) :: binary
  def to_bin(:get_climate_state = msg, _args) do
    cmd_id = ClimateCapability.command_id(msg)
    <<cmd_id>>
  end
end
