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
defmodule AutoApi.TrunkCommandTest do
  use ExUnit.Case
  alias AutoApi.{TrunkCommand, TrunkState}

  describe "execute/2" do
    test "get trunk state command" do
      command = <<0x00>>

      state = TrunkState.put_property(%TrunkState{}, :trunk_lock, :locked)

      assert {:state, new_state} = TrunkCommand.execute(state, command)

      assert new_state == state
    end
  end

  describe "state/1" do
    test "get binary state" do
      state = TrunkState.put_property(%TrunkState{}, :trunk_lock, :locked)

      assert TrunkCommand.state(state) == <<1, 1, 0, 4, 1, 0, 1, 1>>
    end
  end
end
