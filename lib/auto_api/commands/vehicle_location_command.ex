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
  Handles  commands and apply binary commands on `%AutoApi.VehicleLocationState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.VehicleLocationState
  alias AutoApi.VehicleLocationCapability

  @doc """
  Parses the binary command and makes changes or returns the state

        iex> AutoApi.VehicleLocationCommand.execute(%AutoApi.VehicleLocationState{}, <<0x00>>)
        {:state, %AutoApi.VehicleLocationState{}}

        iex> command = <<0x01>> <> <<0x01, 8::integer-16, 12.000001::float-32, 13.000002::float-32>> <> <<0x02, 4::integer-16, 12.00009::float-32>>
        iex> AutoApi.VehicleLocationCommand.execute(%AutoApi.VehicleLocationState{}, command)
        {:state_changed, %AutoApi.VehicleLocationState{coordinates: %{latitude: 12.000001, longitude: 13.000002}, heading: 12.00009, properties: []}}
  """
  @spec execute(VehicleLocationState.t(), binary) ::
          {:state | :state_changed, VehicleLocationState.t()}
  def execute(%VehicleLocationState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%VehicleLocationState{} = state, <<0x01, ds::binary>>) do
    new_state = VehicleLocationState.from_bin(ds)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts DoorLocksCommand state to capability's state in binary

        iex> AutoApi.VehicleLocationCommand.state(%AutoApi.VehicleLocationState{heading: 90.000, properties: [:heading]})
        <<1, 2, 0, 4, 66, 180, 0, 0>>
  """
  @spec state(VehicleLocationState.t()) :: binary
  def state(%VehicleLocationState{} = state) do
    <<0x01, VehicleLocationState.to_bin(state)::binary>>
  end

  @doc """
  Converts command to binary format

      iex> AutoApi.VehicleLocationCommand.to_bin(:get_vehicle_location, [])
      <<0x00>>
  """
  @spec to_bin(VehicleLocationCapability.command_type(), list(any())) :: binary
  def to_bin(:get_vehicle_location, []) do
    cmd_id = VehicleLocationCapability.command_id(:get_vehicle_location)
    <<cmd_id>>
  end
end
