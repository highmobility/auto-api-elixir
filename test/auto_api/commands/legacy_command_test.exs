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
defmodule AutoApiL12.LegacyCommandTest do
  use ExUnit.Case, async: true
  use PropCheck
  import AutoApiL12.PropCheckFixtures

  doctest AutoApiL12.LegacyCommand

  alias AutoApiL12.LegacyCommand, as: SUT
  alias AutoApiL12.SetCommand

  property "state/1 works" do
    forall {_capability, state} <- capability_with_state() do
      command_bin = state |> SetCommand.new() |> SetCommand.to_bin()

      assert SUT.state(state) == command_bin
    end
  end

  property "state/1 works through capability call chain" do
    forall {capability, state} <- capability_with_state() do
      command_bin = state |> SetCommand.new() |> SetCommand.to_bin()

      assert capability.command().state(state) == command_bin
    end
  end
end
