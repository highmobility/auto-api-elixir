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
defmodule AutoApi.VehicleLocationCommand do
  @moduledoc """
  Handles VehicleLocation commands and apply binary commands on `%AutoApi.VehicleLocationState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.VehicleLocationState
  alias AutoApi.VehicleLocationCapability
  @doc """
  Parses the binary command and makes changes or returns the state

        iex> AutoApi.VehicleLocationCommand.execute(%AutoApi.VehicleLocationState{latitude: -1.0, longitude: 2.0}, <<0x00>>)
        {:state, %AutoApi.VehicleLocationState{latitude: -1.0, longitude: 2.0}}

        iex> command = <<0x01, 0x42, 0x52, 0x2C, 0x2E, 0x41, 0x56, 0x7B, 0xE1>>
        iex> AutoApi.VehicleLocationCommand.execute(%AutoApi.VehicleLocationState{latitude: -1.0, longitude: 2.0}, command)
        {:state_changed, %AutoApi.VehicleLocationState{latitude: 52.54314422607422, longitude: 13.405243873596191}}

  """
  @spec execute(VehicleLocationState.t, binary) :: {:state|:state_changed, VehicleLocationState.t}
  def execute(%VehicleLocationState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%VehicleLocationState{} = state, <<0x01, latitude_longitude::binary-size(8)>>) do
    new_state = VehicleLocationState.from_bin(latitude_longitude)
    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts VehicleLocation state to capability's state in binary

        iex> AutoApi.VehicleLocationCommand.state(%AutoApi.VehicleLocationState{latitude: 52.543146, longitude: 13.405244})
        <<0x01, 0x42, 0x52, 0x2C, 0x2E, 0x41, 0x56, 0x7B, 0xE1>>
  """
  @spec state(VehicleLocationState.t) :: <<_::88>>
  def state(%VehicleLocationState{} = state) do
    <<0x01, VehicleLocationState.to_bin(state)::binary-size(8)>>
  end

  @doc """
  Converts VehicleLocation state to capability's vehicle state binary

        iex> AutoApi.VehicleLocationCommand.vehicle_state(%AutoApi.VehicleLocationState{latitude: 52.543146, longitude: 13.405244})
        <<0x08, 0x42, 0x52, 0x2C, 0x2E, 0x41, 0x56, 0x7B, 0xE1>>
  """
  @spec vehicle_state(VehicleLocationState.t) :: <<_::88>>
  def vehicle_state(%VehicleLocationState{} = state) do
    <<0x08, VehicleLocationState.to_bin(state)::binary-size(8)>>
  end

  @doc """
  Converts command to binary format

      iex> AutoApi.VehicleLocationCommand.to_bin(:get_vehicle_location, [])
      <<0x00>>
  """
  @spec to_bin(VehicleLocationCapability.command_type, list(any())) :: binary
  def to_bin(:get_vehicle_location, []) do
    cmd_id = VehicleLocationCapability.command_id(:get_vehicle_location)
    <<cmd_id>>
  end
end
