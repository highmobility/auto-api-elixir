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
defmodule AutoApi.WakeUpCommand do
  @moduledoc """
  Handles WakeUp commands and apply binary commands on `%AutoApi.WakeUpState{}`
  """
  use AutoApi.Command

  alias AutoApi.WakeUpState

  @doc """
  Parses the binary command and makes changes or returns the state
  """
  @spec execute(WakeUpState.t(), binary) :: {:state | :state_changed, WakeUpState.t()}
  def execute(%WakeUpState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%WakeUpState{} = state, <<0x01, ws::binary>>) do
    new_state = WakeUpState.from_bin(ws)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts a WakeUpCommand state to capability's state in binary
  """
  @spec state(WakeUpState.t()) :: binary
  def state(%WakeUpState{} = state) do
    <<0x01, WakeUpState.to_bin(state)::binary>>
  end
end
