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
defmodule AutoApi.PowerTakeoffCommand do
  @moduledoc """
  Handles  commands and apply binary commands on `%AutoApi.PowerTakeoffState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.PowerTakeoffState
  alias AutoApi.PowerTakeoffCapability

  @doc """
  Parses the binary command and makes changes or returns the state

        iex> AutoApi.PowerTakeoffCommand.execute(%AutoApi.PowerTakeoffState{}, <<0x00>>)
        {:state, %AutoApi.PowerTakeoffState{}}

        iex> command = <<0x01>> <> <<0x01, 1::integer-16, 0x01>>
        iex> AutoApi.PowerTakeoffCommand.execute(%AutoApi.PowerTakeoffState{}, command)
        {:state_changed, %AutoApi.PowerTakeoffState{power_takeoff: :active}}

  """
  @spec execute(PowerTakeoffState.t(), binary) :: {:state | :state_changed, PowerTakeoffState.t()}
  def execute(%PowerTakeoffState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%PowerTakeoffState{} = state, <<0x01, ds::binary>>) do
    new_state = PowerTakeoffState.from_bin(ds)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts PowerTakeoffCommand state to capability's state in binary

        iex> AutoApi.PowerTakeoffCommand.state(%AutoApi.PowerTakeoffState{power_takeoff: :active, properties: [:power_takeoff]})
        <<1, 1, 0, 1, 1>>
  """
  @spec state(PowerTakeoffState.t()) :: binary
  def state(%PowerTakeoffState{} = state) do
    <<0x01, PowerTakeoffState.to_bin(state)::binary>>
  end

  @doc """
  Returns binary command
      iex> AutoApi.PowerTakeoffCommand.to_bin(:get_power_takeoff_state, [])
      <<0x00>>
  """
  @spec to_bin(PowerTakeoffCapability.command_type(), list(any)) :: binary
  def to_bin(:get_power_takeoff_state = msg, _args) do
    cmd_id = PowerTakeoffCapability.command_id(msg)
    <<cmd_id>>
  end
end
