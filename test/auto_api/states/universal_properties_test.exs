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
defmodule AutoApi.UniversalPropertiesTest do
  use ExUnit.Case
  alias AutoApi.{DoorLocksState, DiagnosticsState}

  @tag :skip
  test "converts the state properties and the universal properties" do
    bin_state = <<0x04, 2::integer-16, 0x00, 0x01, 0xA2, 0, 8, 18, 6, 8, 16, 8, 2, 0, 120>>

    state = DoorLocksState.from_bin(bin_state)

    datetime = %DateTime{
      year: 2018,
      month: 06,
      day: 08,
      hour: 16,
      minute: 8,
      second: 2,
      utc_offset: 120,
      time_zone: "",
      zone_abbr: "",
      std_offset: 0
    }

    locks = [
      %{door_location: :front_left, position: :open}
    ]

    assert state == %DoorLocksState{positions: locks, timestamp: datetime}
  end
end
