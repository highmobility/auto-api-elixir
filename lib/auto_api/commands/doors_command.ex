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
defmodule AutoApi.DoorsCommand do
  @moduledoc """
  Handles  commands and apply binary commands on `%AutoApi.DoorsState{}`
  """
  use AutoApi.Command

  alias AutoApi.DoorsState

  @doc """
  Converts DoorsCommand state to capability's state in binary

        iex> AutoApi.DoorsCommand.state(%AutoApi.DoorsState{positions: [%{door_location: :front_left, position: :closed}], properties: [:positions]})
        <<1, 4, 0, 2, 0, 0>>
  """
  @spec state(DoorsState.t()) :: binary
  def state(%DoorsState{} = state) do
    <<0x01, DoorsState.to_bin(state)::binary>>
  end
end
