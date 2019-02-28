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
      state =
        %VehicleLocationState{}
        |> VehicleLocationState.put_property(:altitude, 133.5)
        |> VehicleLocationState.put_property(:heading, 0.5)
        |> VehicleLocationState.put_property(:coordinates, %{
          latitude: 52.516506,
          longitude: 13.381815
        })

      command = <<0x01>> <> VehicleLocationState.to_bin(state)

      assert {:state_changed, new_state} =
               VehicleLocationCommand.execute(%VehicleLocationState{}, command)

      assert state == new_state
    end
  end

  describe "state/1" do
    test "converts state to binary" do
      state = VehicleLocationState.put_property(%VehicleLocationState{}, :altitude, 133.5)

      assert VehicleLocationCommand.state(state) == <<0x01>> <> VehicleLocationState.to_bin(state)
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
