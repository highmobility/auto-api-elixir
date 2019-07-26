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
defmodule AutoApi.DoorsCommandTest do
  use ExUnit.Case
  alias AutoApi.{DoorsCommand, DoorsState, PropertyComponent}

  describe "execute/2" do
  #TODO
  @tag :skip
    test "lock_unlock_doors lock command" do
      command = DoorsCommand.to_bin(:set, lock_state: :lock)

      state =
        DoorsState.append_property(%DoorsState{}, :locks, %{
          door_location: :front_right,
          lock_state: :unlocked
        })

      assert {:state_changed, new_state} = DoorsCommand.execute(state, command)

      assert new_state.locks == [
               %PropertyComponent{data: %{door_location: :front_right, lock_state: :locked}}
             ]
    end

  #TODO
  @tag :skip
    test "lock_unlock_doors unlock command" do
      command = DoorsCommand.to_bin(:set, lock_state: :unlock)

      state =
        DoorsState.append_property(%DoorsState{}, :locks, %{
          door_location: :front_right,
          lock_state: :locked
        })

      assert {:state_changed, new_state} = DoorsCommand.execute(state, command)

      assert new_state.locks == [
               %PropertyComponent{data: %{door_location: :front_right, lock_state: :unlocked}}
             ]
    end
  end
end
