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
defmodule AutoApi.ChargingCommand do
  @moduledoc """
  Handles Charging commands and apply binary commands on `%AutoApi.ChargingState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.ChargingState
  alias AutoApi.ChargingCapability

  @doc """
  Parses the binary command and makes changes or returns the state

        iex> AutoApi.ChargingCommand.execute(%AutoApi.ChargingState{}, <<0x00>>)
        {:state, %AutoApi.ChargingState{}}

        iex> command = <<0x01>> <> <<0x01, 1::integer-16, 0x03>>
        iex> AutoApi.ChargingCommand.execute(%AutoApi.ChargingState{}, command)
        {:state_changed, %AutoApi.ChargingState{charging: :charging_complete}}

  """
  @spec execute(ChargingState.t(), binary) :: {:state | :state_changed, ChargingState.t()}
  def execute(%ChargingState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%ChargingState{} = state, <<0x01, ds::binary>>) do
    new_state = ChargingState.from_bin(ds)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts ChargingCommand state to capability's state in binary

        iex> properties = [:battery_level]
        iex> AutoApi.ChargingCommand.state(%AutoApi.ChargingState{battery_level: 01, properties: properties})
        <<1, 3, 0, 1, 1>>
        iex> properties = AutoApi.ChargingCapability.properties |> Enum.into(%{}) |> Map.values()
        iex> AutoApi.ChargingCommand.state(%AutoApi.ChargingState{charge_timer: [%{timer_type: :departure_time, year: 99, month: 10, day: 1, hour: 10, minute: 55, second: 59, utc_time_offset: 30}], properties: properties})
        <<1, 4, 0, 4, 0, 0, 0, 0, 5, 0, 4, 0, 0, 0, 0, 3, 0, 1, 0, 8, 0, 1, 0, 12, 0, 1,\
          1, 11, 0, 1, 0, 13, 0, 9, 2, 99, 10, 1, 10, 55, 59, 0, 30, 6, 0, 4, 0, 0, 0,\
          0, 7, 0, 4, 0, 0, 0, 0, 1, 0, 1, 0, 10, 0, 4, 0, 0, 0, 0, 2, 0, 2, 0, 0, 9, 0,\
          2, 0, 0>>
  """
  @spec state(ChargingState.t()) :: binary
  def state(%ChargingState{} = state) do
    <<0x01, ChargingState.to_bin(state)::binary>>
  end

  @doc """
  Converts command to binary format

      iex> AutoApi.ChargingCommand.to_bin(:get_charge_state, [])
      <<0x00>>
  """
  @spec to_bin(ChargingCapability.command_type(), list(any())) :: binary
  def to_bin(:get_charge_state, []) do
    cmd_id = ChargingCapability.command_id(:get_charge_state)
    <<cmd_id>>
  end
end
