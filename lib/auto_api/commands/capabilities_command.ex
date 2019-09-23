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
  use AutoApi.Command

  alias AutoApi.CapabilitiesState

  @doc """
  Converts VehicleLocation state to capability's state in binary

      ie> AutoApi.CapabilitiesState.to_bin(%AutoApi.CapabilitiesState{diagnostics: [:get_diagnostics_state, :diagnostics_state], door_locks: [:get_lock_state, :lock_state, :lock_unlock_doors]})
      <<1, 0, 4, 0, 0x33, 0, 1, 1, 0, 5, 0, 0x20, 0, 1, 18>>
      ie> AutoApi.CapabilitiesState.to_bin(%AutoApi.CapabilitiesState{diagnostics: [:get_diagnostics_state, :diagnostics_state], door_locks: []})
      <<1, 0, 4, 0, 0x33, 0, 1>>
  """
  @spec state(CapabilitiesState.t()) :: binary
  def state(%CapabilitiesState{} = state) do
    <<0x01, CapabilitiesState.to_bin(state)::binary>>
  end
end
