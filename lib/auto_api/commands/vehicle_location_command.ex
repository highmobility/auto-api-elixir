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

  alias AutoApi.{VehicleLocationCapability, VehicleLocationState}

  @doc """
  Parses the binary command and makes changes or returns the state

  """
  @spec execute(VehicleLocationState.t(), binary) ::
          {:state | :state_changed, VehicleLocationState.t()}
  def execute(%VehicleLocationState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%VehicleLocationState{} = state, <<0x01, state_bin::binary>>) do
    new_state = VehicleLocationState.from_bin(state_bin)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts VehicleLocationState state to capability's state in binary

  """
  @spec state(VehicleLocationState.t()) :: binary
  def state(%VehicleLocationState{} = state) do
    <<0x01, VehicleLocationState.to_bin(state)::binary>>
  end

  @doc """
  Returns binary command
      iex> AutoApi.VehicleLocationCommand.to_bin(:vehicle_location, [])
      <<0x01>>
  """
  @spec to_bin(VehicleLocationCapability.command_type(), list(any)) :: binary
  def to_bin(cmd, _args) when cmd in [:vehicle_location, :get_vehicle_location] do
    cmd_id = VehicleLocationCapability.command_id(cmd)
    <<cmd_id>>
  end
end
