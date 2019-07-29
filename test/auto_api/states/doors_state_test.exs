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
defmodule AutoApi.DoorsStateTest do
  use ExUnit.Case
  doctest AutoApi.DoorsState
  alias AutoApi.DoorsState

  test "to_bin & from_bin" do
    state =
      %DoorsState{}
      |> DoorsState.append_property(:positions, %{
        location: :front_left,
        position: :closed
      })
      |> DoorsState.append_property(:positions, %{
        location: :front_right,
        position: :open
      })
      |> DoorsState.append_property(:inside_locks, %{
        location: :front_right,
        lock_state: :unlocked
      })
      |> DoorsState.append_property(:locks, %{
        location: :front_right,
        lock_state: :unlocked
      })

    new_state =
      state
      |> DoorsState.to_bin()
      |> DoorsState.from_bin()

    assert state == new_state
  end
end
