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
defmodule AutoApi.DoorLocksTest do
  use ExUnit.Case
  alias AutoApi.{DoorLocksCommand, DoorLocksState}
  doctest DoorLocksCommand

  describe "execute/2" do
    test "lock_unlock_doors lock command" do
      command = <<0x012, 0x01, 0x01>>

      state = %DoorLocksState{locks: [%{door_location: :front_left, lock_state: :unlocked}]}
      assert {:state_changed, new_state} = DoorLocksCommand.execute(state, command)
      assert new_state.locks == [%{door_location: :front_left, lock_state: :locked}]
    end

    test "lock_unlock_doors unlock command" do
      command = <<0x012, 0x01, 0x00>>

      state = %DoorLocksState{locks: [%{door_location: :front_left, lock_state: :locked}]}
      assert {:state_changed, new_state} = DoorLocksCommand.execute(state, command)
      assert new_state.locks == [%{door_location: :front_left, lock_state: :unlocked}]
    end
  end
end
