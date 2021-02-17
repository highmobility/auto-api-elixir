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
defmodule AutoApi.CommandTest do
  use ExUnit.Case, async: true
  use PropCheck

  import AutoApi.PropCheckFixtures

  alias AutoApi.{GetAvailabilityCommand, GetCommand, SetCommand}
  alias AutoApi.Command, as: SUT

  doctest AutoApi.Command

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
