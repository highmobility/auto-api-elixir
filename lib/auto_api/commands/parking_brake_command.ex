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
defmodule AutoApi.ParkingBrakeCommand do
  @moduledoc """
  Handles  commands and apply binary commands on `%AutoApi.ParkingBrakeState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.ParkingBrakeState
  alias AutoApi.ParkingBrakeCapability

  @doc """
  Parses the binary command and makes changes or returns the state

        iex> AutoApi.ParkingBrakeCommand.execute(%AutoApi.ParkingBrakeState{}, <<0x00>>)
        {:state, %AutoApi.ParkingBrakeState{}}

        iex> command = <<0x01>> <> <<0x01, 1::integer-16, 0x01>>
        iex> AutoApi.ParkingBrakeCommand.execute(%AutoApi.ParkingBrakeState{}, command)
        {:state_changed, %AutoApi.ParkingBrakeState{parking_brake: :active}}

  """
  @spec execute(ParkingBrakeState.t(), binary) :: {:state | :state_changed, ParkingBrakeState.t()}
  def execute(%ParkingBrakeState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%ParkingBrakeState{} = state, <<0x01, ds::binary>>) do
    new_state = ParkingBrakeState.from_bin(ds)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts ParkingBrakeCommand state to capability's state in binary

        iex> AutoApi.ParkingBrakeCommand.state(%AutoApi.ParkingBrakeState{parking_brake: :inactive, properties: [:parking_brake]})
        <<1, 1, 0, 1, 0>>
  """
  @spec state(ParkingBrakeState.t()) :: binary
  def state(%ParkingBrakeState{} = state) do
    <<0x01, ParkingBrakeState.to_bin(state)::binary>>
  end

  @doc """
  Returns binary command
      iex> AutoApi.ParkingBrakeCommand.to_bin(:get_parking_brake_state, [])
      <<0x00>>
  """
  @spec to_bin(ParkingBrakeCapability.command_type(), list(any)) :: binary
  def to_bin(:get_parking_brake_state = msg, _args) do
    cmd_id = ParkingBrakeCapability.command_id(msg)
    <<cmd_id>>
  end
end
