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
defmodule AutoApi.CommandTest do
  use ExUnit.Case
  alias AutoApi.{Command, DiagnosticsState, DiagnosticsCapability}
  doctest AutoApi.Command

  describe "to_bin/3" do
    test "convert diagnostics_state command" do
      state =
        %DiagnosticsState{}
        |> DiagnosticsState.put_property(:mileage, 100)
        |> DiagnosticsState.put_property(:fuel_level, 10)

      expected_bin = DiagnosticsCapability.identifier() <> <<1>> <> DiagnosticsState.to_bin(state)
      assert Command.to_bin(:diagnostics, :diagnostics_state, [state]) == expected_bin
    end
  end
end
