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
defmodule AutoApi.ChargingCommandTest do
  use ExUnit.Case
  alias AutoApi.{ChargingCommand, ChargingState, PropertyComponent}

  describe "execute/2" do
  #TODO
  @tag :skip
    test "get_charge_state" do
      assert ChargingCommand.execute(%ChargingState{}, <<0x00>>) == {:state, %ChargingState{}}
    end

  #TODO
  @tag :skip
    test "charge_state" do
      estimated_range_prop = %PropertyComponent{data: 100}
      binary_state = ChargingState.to_bin(%ChargingState{estimated_range: estimated_range_prop})

      assert ChargingCommand.execute(%ChargingState{}, <<0x01, binary_state::binary>>) ==
               {:state_changed, %ChargingState{estimated_range: estimated_range_prop}}
    end
  end

  describe "state/1" do
  #TODO
  @tag :skip
    test "get state" do
      state = %ChargingState{estimated_range: %PropertyComponent{data: 100}}

      assert ChargingCommand.state(state) == <<0x01>> <> ChargingState.to_bin(state)
    end
  end
end
