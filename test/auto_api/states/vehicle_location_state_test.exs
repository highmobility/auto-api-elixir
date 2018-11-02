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
defmodule AutoApi.VehicleLocationStateTest do
  use ExUnit.Case
  alias AutoApi.VehicleLocationState

  describe "to_bin/1" do
    test "converts altitude to bin" do
      state = %AutoApi.VehicleLocationState{
        altitude: 133.5,
        properties: [:altitude, :coordinates]
      }

      assert VehicleLocationState.to_bin(state) == <<6, 0, 8, 133.5::float-64>>
    end

    test "converts coordinates to binary" do
      [lat, long] = [52.516506, 13.381815]

      state = %AutoApi.VehicleLocationState{
        coordinates: %{latitude: lat, longitude: long},
        properties: [:coordinates]
      }

      assert VehicleLocationState.to_bin(state) ==
               <<0x04, 16::integer-16, lat::float-64, long::float-64>>
    end
  end

  describe "from_bin/1" do
    test "converts not repeatable data to state" do
      [lat, long] = [52.516506, 13.381815]

      vlocation = <<0x04, 16::integer-16, lat::float-64, long::float-64>>

      state = VehicleLocationState.from_bin(vlocation)
      assert state.coordinates == %{latitude: 52.516506, longitude: 13.381815}
    end

    test "converts binary data to state" do
      [lat, long, alt, heading] = [52.516506, 13.381815, 133.5, 84.828]

      vlocation =
        <<0x04, 16::integer-16, lat::float-64, long::float-64>> <>
          <<6, 0, 8, alt::float-64>> <> <<5, 0, 8, heading::float-64>>

      state = VehicleLocationState.from_bin(vlocation)
      assert state.altitude == alt
      assert state.coordinates == %{latitude: 52.516506, longitude: 13.381815}
      assert state.heading == heading
    end
  end
end
