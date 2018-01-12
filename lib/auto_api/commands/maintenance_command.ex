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
defmodule AutoApi.MaintenanceCommand do
  @moduledoc """
  Handles Maintenance commands and apply binary commands on `%AutoApi.MaintenanceState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.MaintenanceState
  alias AutoApi.MaintenanceCapability
  @doc """
  Parses the binary command and makes changes or returns the state

        iex> AutoApi.MaintenanceCommand.execute(%AutoApi.MaintenanceState{next_service_in_days: 8, next_service_in_km: 38}, <<0x00>>)
        {:state, %AutoApi.MaintenanceState{next_service_in_days: 8, next_service_in_km: 38}}

        iex> command = <<0x01, 98::integer-16, 1000::integer-24>>
        iex> AutoApi.MaintenanceCommand.execute(%AutoApi.MaintenanceState{}, command)
        {:state_changed, %AutoApi.MaintenanceState{next_service_in_days: 98, next_service_in_km: 1000}}

  """
  @spec execute(MaintenanceState.t, binary) :: {:state|:state_changed, MaintenanceState.t}
  def execute(%MaintenanceState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%MaintenanceState{} = state, <<0x01, services_in_days_km::binary-size(5)>>) do
    new_state = MaintenanceState.from_bin(services_in_days_km)
    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts VehicleLocation state to capability's state in binary

        iex> AutoApi.MaintenanceCommand.state(%AutoApi.MaintenanceState{next_service_in_days: 98, next_service_in_km: 1000})
        <<0x1, 98::integer-16, 1000::integer-24>>
  """
  @spec state(MaintenanceState.t) :: <<_::64>>
  def state(%MaintenanceState{} = state) do
    <<0x01, MaintenanceState.to_bin(state)::binary-size(5)>>
  end

  @doc """
  Converts VehicleLocation state to capability's vehicle state binary

        iex> AutoApi.MaintenanceCommand.vehicle_state(%AutoApi.MaintenanceState{next_service_in_days: 1000, next_service_in_km: 10_000_000})
        <<0x05, 1000::integer-16, 10_000_000::integer-24>>
  """
  @spec vehicle_state(MaintenanceState.t) :: <<_::64>>
  def vehicle_state(%MaintenanceState{} = state) do
    <<0x05, MaintenanceState.to_bin(state)::binary-size(5)>>
  end

  @doc """
  Converts command to binary format

      iex> AutoApi.MaintenanceCommand.to_bin(:get_maintenance_state, [])
      <<0x00>>
  """
  @spec to_bin(MaintenanceCapability.command_type, list(any())) :: binary
  def to_bin(:get_maintenance_state, []) do
    cmd_id = MaintenanceCapability.command_id(:get_maintenance_state)
    <<cmd_id>>
  end
end
