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
defmodule AutoApiL12.SetCommandTest do
  use ExUnit.Case, async: true
  use PropCheck

  import AutoApiL12.PropCheckFixtures
  import Assertions, only: [assert_lists_equal: 2]

  doctest AutoApiL12.SetCommand

  alias AutoApiL12.SetCommand, as: SUT

  property "new/1 works" do
    forall {capability, state} <- capability_with_state() do
      command = SUT.new(state)

      assert %SUT{capability: capability, state: state} == command
    end
  end

  property "new/2 works" do
    forall {capability, state} <- capability_with_state() do
      command = SUT.new(capability, state)

      assert %SUT{capability: capability, state: state} == command
    end
  end

  describe "properties/1" do
    property "works with empty state" do
      forall capability <- capability() do
        state = capability.state().base()
        command = SUT.new(state)

        assert SUT.properties(command) == []
      end
    end

    test "works with set commands with some filled state" do
      # No point in using propcheck here, we would have to  duplicate the
      # implementation code in the test for the comparison
      state =
        AutoApiL12.DiagnosticsState.base()
        |> AutoApiL12.State.put(:fuel_level, data: 0.89)
        |> AutoApiL12.State.put(:estimated_range, timestamp: DateTime.utc_now())
        |> AutoApiL12.State.put(:check_control_messages,
          failure: %{reason: :unknown, description: ""}
        )
        |> AutoApiL12.State.put(:tire_pressures,
          availability: %{
            update_rate: :trip,
            rate_limit: %{unit: :hertz, value: 1.0},
            applies_per: :vehicle
          }
        )

      command = SUT.new(state)

      assert_lists_equal(SUT.properties(command), [
        :estimated_range,
        :fuel_level,
        :tire_pressures,
        :check_control_messages
      ])
    end
  end

  property "to_bin/1 and from_bin/1 are inverse" do
    forall {capability, state} <- capability_with_state() do
      command = SUT.new(capability, state)

      assert cmd_bin = SUT.to_bin(command)
      assert command == SUT.from_bin(cmd_bin)
    end
  end
end
