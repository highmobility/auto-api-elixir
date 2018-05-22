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
defmodule AutoApi.VehicleTimeCommand do
  @moduledoc """
  Handles  commands and apply binary commands on `%AutoApi.VehicleTimeState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.VehicleTimeState
  alias AutoApi.VehicleTimeCapability

  @doc """
  Parses the binary command and makes changes or returns the state

        iex> AutoApi.VehicleTimeCommand.execute(%AutoApi.VehicleTimeState{}, <<0x00>>)
        {:state, %AutoApi.VehicleTimeState{}}

        iex> command = <<0x01>> <> <<0x01, 8::integer-16, 99, 1, 31, 23, 59, 0, 4::integer-16>>
        iex> AutoApi.VehicleTimeCommand.execute(%AutoApi.VehicleTimeState{}, command)
        {:state_changed, %AutoApi.VehicleTimeState{vehicle_time: %{day: 31, hour: 23, minute: 59, month: 1, second: 0, utc_time_offset: 4, year: 99}}}
  """
  @spec execute(VehicleTimeState.t(), binary) :: {:state | :state_changed, VehicleTimeState.t()}
  def execute(%VehicleTimeState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%VehicleTimeState{} = state, <<0x01, ds::binary>>) do
    new_state = VehicleTimeState.from_bin(ds)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts DoorLocksCommand state to capability's state in binary

        iex> vehicle_time = %{day: 31, hour: 23, minute: 59, month: 1, second: 0, utc_time_offset: 4, year: 91}
        iex> AutoApi.VehicleTimeCommand.state(%AutoApi.VehicleTimeState{vehicle_time: vehicle_time, properties: [:vehicle_time]})
        <<1, 1, 0, 8, 91, 1, 31, 23, 59, 0, 0, 4>>
  """
  @spec state(VehicleTimeState.t()) :: binary
  def state(%VehicleTimeState{} = state) do
    <<0x01, VehicleTimeState.to_bin(state)::binary>>
  end

  @doc """
  Returns binary command
      iex> AutoApi.VehicleTimeCommand.to_bin(:get_vehicle_time, [])
      <<0x00>>
  """
  @spec to_bin(VehicleTimeCapability.command_type(), list(any)) :: binary
  def to_bin(:get_vehicle_time = msg, _args) do
    cmd_id = VehicleTimeCapability.command_id(msg)
    <<cmd_id>>
  end
end
