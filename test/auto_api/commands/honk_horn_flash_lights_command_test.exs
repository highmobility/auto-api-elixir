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
defmodule AutoApi.HonkHornFlashLightsTest do
  use ExUnit.Case
  alias AutoApi.{HonkHornFlashLightsCommand, HonkHornFlashLightsState}

  describe "execute/2" do
    test "get state" do
      command = <<0>>

      state = %HonkHornFlashLightsState{}
      assert {:state, new_state} = HonkHornFlashLightsCommand.execute(state, command)
      assert state == new_state
    end

    test "turn on flash lights" do
      state = %HonkHornFlashLightsState{}
      command = HonkHornFlashLightsCommand.to_bin(:honk_flash, seconds: 1, flash: 2)
      assert {:state, new_state} = HonkHornFlashLightsCommand.execute(state, command)
      assert state == new_state
    end
  end
end
