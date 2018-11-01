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
defmodule AutoApi.ChargingStateTest do
  use ExUnit.Case
  doctest AutoApi.ChargingState

  describe "from_bin/1" do
    test "with a list properties" do
      state = AutoApi.ChargingState.from_bin(<<0x11, 3::integer-16, 0x01, 0x12, 0x01>>)

      expected_state = %AutoApi.ChargingState{
        departure_times: [%{active_state: :active, hour: 18, minute: 1}]
      }

      assert state == expected_state
    end
  end
end
