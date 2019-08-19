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
defmodule AutoApi.TrunkCommand do
  @moduledoc """
  Handles  commands and apply binary commands on `%AutoApi.TrunkState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.TrunkState

  @spec execute(TrunkState.t(), binary) :: {:state | :state_changed, TrunkState.t()}
  def execute(%TrunkState{} = state, <<0x00>>) do
    {:state, state}
  end

  @spec state(TrunkState.t()) :: binary
  def state(%TrunkState{} = state) do
    <<0x01, TrunkState.to_bin(state)::binary>>
  end
end
