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
defmodule AutoApi.ClimateStateTest do
  use ExUnit.Case
  doctest AutoApi.ClimateState

  alias AutoApi.ClimateState

  describe "regressions" do
    test "hvac_weekday_starting_time is (de)serialized correctly" do
      starting_time = %{
        time: %{hour: 18, minute: 30},
        weekday: :monday
      }

      state_base = ClimateState.base()

      state =
        ClimateState.append_property(state_base, :hvac_weekday_starting_times, starting_time)

      assert state ==
               state
               |> ClimateState.to_bin()
               |> ClimateState.from_bin()
    end
  end
end
