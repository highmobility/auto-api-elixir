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
defmodule AutoApi.DoorLocksStateTest do
  use ExUnit.Case
  alias AutoApi.DoorLocksState

  test "to_bin & from_bin" do
    state =
      %DoorLocksState{}
      |> DoorLocksState.append_property(:positions, %{
        door_location: :front_left,
        position: :closed
      })
      |> DoorLocksState.append_property(:positions, %{
        door_location: :front_right,
        position: :open
      })
      |> DoorLocksState.append_property(:inside_locks, %{
        door_location: :front_right,
        lock_state: :unlocked
      })
      |> DoorLocksState.append_property(:locks, %{
        door_location: :front_right,
        lock_state: :unlocked
      })

    new_state =
      state
      |> DoorLocksState.to_bin()
      |> DoorLocksState.from_bin()

    assert state == new_state
  end
end
