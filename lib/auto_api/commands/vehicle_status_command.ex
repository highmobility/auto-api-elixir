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
defmodule AutoApi.VehicleStatusCommand do
  @moduledoc """
  Handles  commands and apply binary commands on `%AutoApi.VehicleStatusState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.VehicleStatusState
  alias AutoApi.VehicleStatusCapability

  @doc """
  Parses the binary command and makes changes or returns the state
  """
  @spec execute(VehicleStatusState.t(), binary) ::
          {:state | :state_changed, VehicleStatusState.t()}
  def execute(%VehicleStatusState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%VehicleStatusState{} = state, <<0x01, ds::binary>>) do
    new_state = VehicleStatusState.from_bin(ds)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts DoorLocksCommand state to capability's state in binary
  """
  @spec state(VehicleStatusState.t()) :: binary
  def state(%VehicleStatusState{} = state) do
    <<0x01, VehicleStatusState.to_bin(state)::binary>>
  end

  @doc """
  Returns binary command
  """
  @spec to_bin(VehicleStatusCapability.command_type(), list(any)) :: binary
  def to_bin(:get_vehicle_status = msg, _args) do
    cmd_id = VehicleStatusCapability.command_id(msg)
    <<cmd_id>>
  end
end
