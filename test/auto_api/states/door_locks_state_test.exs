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
defmodule AutoApi.DoorLocksStateTest do
  use ExUnit.Case
  alias AutoApi.DoorLocksState
  doctest DoorLocksState

  test "converts all properties to state" do
    state =
      DoorLocksState.from_bin(
        <<0x01, 3::integer-16, 0x00, 0x01, 0x00>> <>
          <<0x02, 2::integer-16, 0x01, 0x00>> <> <<0x03, 2::integer-16, 0x02, 0x01>>
      )

    assert state == %DoorLocksState{
             door: [%{door_location: :front_left, door_lock: :unlocked, door_position: :open}],
             inside_door_lock: [%{door_location: :front_right, inside_lock: :unlocked}],
             outside_door_lock: [%{door_location: :rear_right, outside_lock: :locked}]
           }
  end

  test "converts all properties to binary" do
    bin =
      DoorLocksState.to_bin(%DoorLocksState{
        door: [%{door_location: :front_left, door_lock: :unlocked, door_position: :open}],
        inside_door_lock: [%{door_location: :rear_left, inside_lock: :locked}],
        outside_door_lock: [%{door_location: :rear_right, outside_lock: :locked}],
        properties: [:door, :inside_door_lock, :outside_door_lock]
      })

    assert bin ==
             <<0x01, 3::integer-16, 0x00, 0x01, 0x00>> <>
               <<0x02, 2::integer-16, 0x03, 0x01>> <> <<0x03, 2::integer-16, 0x02, 0x01>>
  end
end
