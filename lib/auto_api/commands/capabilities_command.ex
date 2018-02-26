
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
defmodule AutoApi.CapabilitiesCommand do
  @moduledoc """
  Handles Capabilities commands and apply binary commands on `%AutoApi.CapabilitiesState{}`
  """
  @behaviour AutoApi.Command

  import AutoApi.Capability, only: [list_capabilities: 0]

  alias AutoApi.CapabilitiesState
  alias AutoApi.CapabilitiesCapability

  @doc """
  Parses the binary command and makes changes or returns the state

      iex> AutoApi.CapabilitiesCommand.execute(%AutoApi.CapabilitiesState{}, <<0x00>>)
      {:state, %AutoApi.CapabilitiesState{}}

      iex> state = %AutoApi.CapabilitiesState{diagnostics: [:get_diagnostics_state], door_locks: [:get_door_locks]}
      iex> AutoApi.CapabilitiesCommand.execute(state, <<0x02, 0x00, 0x33>>)
      {:state_changed, %AutoApi.CapabilitiesState{diagnostics: [:get_diagnostics_state], door_locks: []}}
  """
  @spec execute(CapabilitiesState.t(), binary) :: {:state | :state_changed, CapabilitiesState.t()}
  def execute(%CapabilitiesState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%CapabilitiesState{} = state, <<0x01, cs::binary>>) do
    new_state = CapabilitiesState.from_bin(cs)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  def execute(%CapabilitiesState{} = state, <<0x02, capability_id :: binary-size(2)>>) do
    capability_name = list_capabilities()
                      |> Map.get(capability_id)
                      |> apply(:name, [])

    new_state = struct(%CapabilitiesState{}, [{capability_name, Map.get(state, capability_name)}])

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts VehicleLocation state to capability's state in binary

      iex> AutoApi.CapabilitiesState.to_bin(%AutoApi.CapabilitiesState{diagnostics: [:get_diagnostics_state, :diagnostics_state], door_locks: [:get_lock_state, :lock_state, :lock_unlock_doors]})
      <<1, 0, 4, 0, 0x33, 0, 1, 1, 0, 5, 0, 0x20, 0, 1, 2>>
      iex> AutoApi.CapabilitiesState.to_bin(%AutoApi.CapabilitiesState{diagnostics: [:get_diagnostics_state, :diagnostics_state], door_locks: []})
      <<1, 0, 4, 0, 0x33, 0, 1>>
  """
  @spec state(CapabilitiesState.t()) :: binary
  def state(%CapabilitiesState{} = state) do
    <<0x01, CapabilitiesState.to_bin(state)::binary>>
  end

  @doc """
  Converts command to binary format

      iex> AutoApi.CapabilitiesCommand.to_bin(:get_capabilities, [])
      <<0x00>>
      iex> caps = %AutoApi.CapabilitiesState{diagnostics: [:get_diagnostics_state, :diagnostics_state], door_locks: [:lock_unlock_doors]}
      iex> AutoApi.CapabilitiesCommand.to_bin(:capabilities, [caps])
      <<1, 1, 0, 4, 0, 51, 0, 1, 1, 0, 3, 0, 32, 2>>
  """
  @spec to_bin(CapabilitiesCapability.command_type(), list(any())) :: binary
  def to_bin(:get_capabilities, []) do
    cmd_id = CapabilitiesCapability.command_id(:get_capabilities)
    <<cmd_id>>
  end

  def to_bin(:capabilities, [capability_state]) do
    state(capability_state)
  end
end
