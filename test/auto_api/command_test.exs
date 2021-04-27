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
defmodule AutoApiL12.CommandTest do
  use ExUnit.Case, async: true
  use PropCheck

  import AutoApiL12.PropCheckFixtures
  import Assertions, only: [assert_lists_equal: 2]

  alias AutoApiL12.{GetAvailabilityCommand, GetCommand, SetCommand}
  alias AutoApiL12.Command, as: SUT

  doctest AutoApiL12.Command

  describe "identifier/1" do
    property "works with get_availability commands" do
      forall {capability, properties} <- capability_with_properties() do
        command = %GetAvailabilityCommand{capability: capability, properties: properties}

        assert SUT.identifier(command) == 0x02
      end
    end

    property "works with get commands" do
      forall {capability, properties} <- capability_with_properties() do
        command = %GetCommand{capability: capability, properties: properties}

        assert SUT.identifier(command) == 0x00
      end
    end

    property "works with set commands" do
      forall {capability, state} <- capability_with_state() do
        command = %SetCommand{capability: capability, state: state}

        assert SUT.identifier(command) == 0x01
      end
    end
  end

  describe "name/1" do
    property "works with get_availability commands" do
      forall {capability, properties} <- capability_with_properties() do
        command = %GetAvailabilityCommand{capability: capability, properties: properties}

        assert SUT.name(command) == :get_availability
      end
    end

    property "works with get commands" do
      forall {capability, properties} <- capability_with_properties() do
        command = %GetCommand{capability: capability, properties: properties}

        assert SUT.name(command) == :get
      end
    end

    property "works with set commands" do
      forall {capability, state} <- capability_with_state() do
        command = %SetCommand{capability: capability, state: state}

        assert SUT.name(command) == :set
      end
    end
  end

  describe "properties/1" do
    property "works with get_availability commands" do
      forall {capability, properties} <- capability_with_properties() do
        command = %GetAvailabilityCommand{capability: capability, properties: properties}

        expected =
          case properties do
            [] -> capability.state_properties()
            properties -> properties
          end

        assert SUT.properties(command) == expected
      end
    end

    property "works with get commands" do
      forall {capability, properties} <- capability_with_properties() do
        command = %GetCommand{capability: capability, properties: properties}

        expected =
          case properties do
            [] -> capability.state_properties()
            properties -> properties
          end

        assert SUT.properties(command) == expected
      end
    end

    property "works with set commands with empty state" do
      forall capability <- capability() do
        state = capability.state().base()
        command = %SetCommand{capability: capability, state: state}

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

      command = SetCommand.new(state)

      assert_lists_equal(SUT.properties(command), [
        :estimated_range,
        :fuel_level,
        :tire_pressures,
        :check_control_messages
      ])
    end
  end

  describe "from_bin/1" do
    property "works with get_availability commands" do
      forall {capability, properties} <- capability_with_properties() do
        command = %GetAvailabilityCommand{capability: capability, properties: properties}
        command_bin = GetAvailabilityCommand.to_bin(command)

        assert command == SUT.from_bin(command_bin)
      end
    end

    property "works with get commands" do
      forall {capability, properties} <- capability_with_properties() do
        command = %GetCommand{capability: capability, properties: properties}
        command_bin = GetCommand.to_bin(command)

        assert command == SUT.from_bin(command_bin)
      end
    end

    property "works with set commands" do
      forall {capability, state} <- capability_with_state() do
        command = %SetCommand{capability: capability, state: state}
        command_bin = SetCommand.to_bin(command)

        assert command == SUT.from_bin(command_bin)
      end
    end
  end

  describe "to_bin/1" do
    property "works with get_availability commands" do
      forall {capability, properties} <- capability_with_properties() do
        command = %GetAvailabilityCommand{capability: capability, properties: properties}

        assert command_bin = SUT.to_bin(command)
        assert command == GetAvailabilityCommand.from_bin(command_bin)
      end
    end

    property "works with get commands" do
      forall {capability, properties} <- capability_with_properties() do
        command = %GetCommand{capability: capability, properties: properties}

        assert command_bin = SUT.to_bin(command)
        assert command == GetCommand.from_bin(command_bin)
      end
    end

    property "works with set commands" do
      forall {capability, state} <- capability_with_state() do
        command = %SetCommand{capability: capability, state: state}

        assert command_bin = SUT.to_bin(command)
        assert command == SetCommand.from_bin(command_bin)
      end
    end
  end

  describe "to_bin and from_bin are inverse/1" do
    property "works with get_availability commands" do
      forall {capability, properties} <- capability_with_properties() do
        command = %GetAvailabilityCommand{capability: capability, properties: properties}

        assert command_bin = SUT.to_bin(command)
        assert command == SUT.from_bin(command_bin)
      end
    end

    property "works with get commands" do
      forall {capability, properties} <- capability_with_properties() do
        command = %GetCommand{capability: capability, properties: properties}

        assert command_bin = SUT.to_bin(command)
        assert command == SUT.from_bin(command_bin)
      end
    end

    property "works with set commands" do
      forall {capability, state} <- capability_with_state() do
        command = %SetCommand{capability: capability, state: state}

        assert command_bin = SUT.to_bin(command)
        assert command == SUT.from_bin(command_bin)
      end
    end
  end
end
