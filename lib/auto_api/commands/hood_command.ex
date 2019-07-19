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
defmodule AutoApi.HoodCommand do
  @moduledoc """
  Handles Hood commands and apply binary commands on `%AutoApi.HoodState{}`
  """
  use AutoApi.Command

  alias AutoApi.HoodState
  alias AutoApi.HoodCapability

  @doc """
  Parses the binary command and makes changes or returns the state
  """
  @spec execute(HoodState.t(), binary) :: {:state | :state_changed, HoodState.t()}
  def execute(%HoodState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%HoodState{} = state, <<0x01, ds::binary>>) do
    new_state = HoodState.from_bin(ds)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts HoodCommand state to capability's state in binary
  """
  @spec state(HoodState.t()) :: binary
  def state(%HoodState{} = state) do
    <<0x01, HoodState.to_bin(state)::binary>>
  end
end
