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
defmodule AutoApi.WindowsCommand do
  @moduledoc """
  Handles Windows commands and apply binary commands on `%AutoApi.WindowsState{}`
  """
  use AutoApi.Command

  alias AutoApi.WindowsState

  @doc """
  Parses the binary command and makes changes or returns the state
  """
  @spec execute(WindowsState.t(), binary) :: {:state | :state_changed, WindowsState.t()}
  def execute(%WindowsState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%WindowsState{} = state, <<0x01, ws::binary>>) do
    new_state = WindowsState.from_bin(ws)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  def execute(%WindowsState{} = _state, <<0x12, _payload::binary>>) do
    # TODO
    raise "Not implemented!"
  end

  @doc """
  Converts a WindowsCommand state to capability's state in binary
  """
  @spec state(WindowsState.t()) :: binary
  def state(%WindowsState{} = state) do
    <<0x01, WindowsState.to_bin(state)::binary>>
  end
end
