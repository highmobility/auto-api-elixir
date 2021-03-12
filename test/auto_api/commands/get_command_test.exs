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
defmodule AutoApi.GetCommandTest do
  use ExUnit.Case, async: true
  use PropCheck
  import AutoApi.PropCheckFixtures

  doctest AutoApi.GetCommand

  alias AutoApi.GetCommand, as: SUT

  property "new/2 works" do
    forall {capability, properties} <- capability_with_properties() do
      command = SUT.new(capability, properties)

      assert %SUT{capability: capability, properties: properties} == command
    end
  end

  property "property/1 works" do
    forall {capability, properties} <- capability_with_properties() do
      command = SUT.new(capability, properties)

      expected =
        case properties do
          [] -> capability.state_properties()
          properties -> properties
        end

      assert SUT.properties(command) == expected
    end
  end

  property "to_bin/1 and from_bin/1 are inverse" do
    forall {capability, properties} <- capability_with_properties() do
      command = SUT.new(capability, properties)

      assert cmd_bin = SUT.to_bin(command)
      assert command == SUT.from_bin(cmd_bin)
    end
  end
end
