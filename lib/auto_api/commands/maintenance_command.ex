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
  Handles  commands and apply binary commands on `%AutoApi.MaintenanceState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.MaintenanceState
  alias AutoApi.MaintenanceCapability

  @doc """
  Parses the binary command and makes changes or returns the state

        iex> AutoApi.MaintenanceCommand.execute(%AutoApi.MaintenanceState{}, <<0x00>>)
        {:state, %AutoApi.MaintenanceState{}}

        iex> command = <<0x01>> <> <<0x01, 2::integer-16, 0x01, 0x00>>
        iex> AutoApi.MaintenanceCommand.execute(%AutoApi.MaintenanceState{}, command)
        {:state_changed, %AutoApi.MaintenanceState{days_to_next_service: 256}}

  """
  @spec execute(MaintenanceState.t(), binary) :: {:state | :state_changed, MaintenanceState.t()}
  def execute(%MaintenanceState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%MaintenanceState{} = state, <<0x01, ds::binary>>) do
    new_state = MaintenanceState.from_bin(ds)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts MaintenanceCommand state to capability's state in binary

        iex> AutoApi.MaintenanceCommand.state(%AutoApi.MaintenanceState{days_to_next_service: 100, properties: [:days_to_next_service]})
        <<1, 1, 0, 2, 0, 100>>
  """
  @spec state(MaintenanceState.t()) :: binary
  def state(%MaintenanceState{} = state) do
    <<0x01, MaintenanceState.to_bin(state)::binary>>
  end

  @doc """
  Returns binary command
      iex> AutoApi.MaintenanceCommand.to_bin(:get_maintenance_state, [])
      <<0x00>>
  """
  @spec to_bin(MaintenanceCapability.command_type(), list(any)) :: binary
  def to_bin(:get_maintenance_state = msg, _args) do
    cmd_id = MaintenanceCapability.command_id(msg)
    <<cmd_id>>
  end
end
