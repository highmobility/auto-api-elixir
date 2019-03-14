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
defmodule AutoApi.DiagnosticsCommandTest do
  use ExUnit.Case
  alias AutoApi.{DiagnosticsCommand, DiagnosticsState, PropertyComponent}

  describe "execute/2" do
    test "get_diagnostics_state" do
      assert DiagnosticsCommand.execute(%DiagnosticsState{}, <<0x00>>) ==
               {:state, %AutoApi.DiagnosticsState{}}
    end

    test "diagnostics_state" do
      mileage_prop = %PropertyComponent{data: 100}

      binary_state = DiagnosticsState.to_bin(%DiagnosticsState{mileage: mileage_prop})

      assert DiagnosticsCommand.execute(%DiagnosticsState{}, <<0x01, binary_state::binary>>) ==
               {:state_changed, %AutoApi.DiagnosticsState{mileage: mileage_prop}}
    end
  end

  describe "state/1" do
    test "get state" do
      state = %DiagnosticsState{mileage: %PropertyComponent{data: 100}}

      assert DiagnosticsCommand.state(state) == <<0x01>> <> DiagnosticsState.to_bin(state)
    end
  end

  describe "to_bin/2" do
    test "get state command" do
      state = %DiagnosticsState{mileage: %PropertyComponent{data: 100}}

      assert DiagnosticsCommand.to_bin(:diagnostics_state, [state]) ==
               <<0x01>> <> DiagnosticsState.to_bin(state)
    end
  end
end
