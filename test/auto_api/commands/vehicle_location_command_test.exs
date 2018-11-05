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
defmodule AutoApi.VehicleLocationCommandTest do
  use ExUnit.Case
  alias AutoApi.{VehicleLocationCommand, VehicleLocationState}
  doctest VehicleLocationCommand

  describe "execute/2" do
    test "get_vehicle_location command" do
      state = %VehicleLocationState{}
      assert VehicleLocationCommand.execute(%VehicleLocationState{}, <<0x00>>) == {:state, state}
    end

    test "vehicle_location command" do
      [lat, long, alt, heading] = [52.516506, 13.381815, 133.5, 84.828]

      vlocation =
        <<0x04, 16::integer-16, lat::float-64, long::float-64>> <>
          <<6, 0, 8, alt::float-64>> <> <<5, 0, 8, heading::float-64>>

      command = <<0x01>> <> vlocation

      assert {:state_changed, state} =
               VehicleLocationCommand.execute(%VehicleLocationState{}, command)

      assert state.altitude == alt
      assert state.heading == heading
      assert state.coordinates.latitude == lat
      assert state.coordinates.longitude == long
    end
  end

  describe "state/1" do
    test "converts state to binary" do
      state = %VehicleLocationState{heading: 82.828, properties: [:heading]}

      assert VehicleLocationCommand.state(state) ==
               <<0x01, 0x05, 8::integer-16, 82.828::float-64>>
    end
  end

  describe "to_bin/2" do
    test "converts get_vehicle_location" do
      assert VehicleLocationCommand.to_bin(:get_vehicle_location, []) == <<0>>
    end

    test "converts vehicle_location" do
      assert VehicleLocationCommand.to_bin(:vehicle_location, []) == <<1>>
    end
  end
end
