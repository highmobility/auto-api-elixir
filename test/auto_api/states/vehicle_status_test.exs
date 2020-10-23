# AutoAPI
# The MIT License
#
# Copyright (c) 2018- High-Mobility GmbH (https://high-mobility.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
defmodule AutoApi.VehicleStatusStateTest do
  use ExUnit.Case, async: true
  doctest AutoApi.VehicleStatusState
  alias AutoApi.VehicleStatusState

  test "Correctly encodes state in to_bin/1" do
    diag_state =
      AutoApi.DiagnosticsState.base()
      |> AutoApi.DiagnosticsState.put_property(:speed, {88, :miles_per_hour}, DateTime.utc_now())

    door_state =
      AutoApi.DoorsState.base()
      |> AutoApi.DoorsState.append_property(:positions, %{
        door_location: :front_left,
        position: :closed
      })

    diag_state_bin =
      AutoApi.DiagnosticsState.identifier() <>
        <<0x01>> <> AutoApi.DiagnosticsState.to_bin(diag_state)

    diag_state_bin_size = byte_size(diag_state_bin)

    door_state_bin =
      AutoApi.DoorsState.identifier() <> <<0x01>> <> AutoApi.DoorsState.to_bin(door_state)

    door_state_bin_size = byte_size(door_state_bin)

    state =
      VehicleStatusState.base()
      |> VehicleStatusState.append_property(:states, diag_state)
      |> VehicleStatusState.append_property(:states, door_state)
      |> VehicleStatusState.to_bin()

    assert state ==
             <<0x99, diag_state_bin_size + 3::integer-16, 0x01, diag_state_bin_size::integer-16,
               diag_state_bin::binary, 0x99, door_state_bin_size + 3::integer-16, 0x01,
               door_state_bin_size::integer-16, door_state_bin::binary>>
  end

  test "Correctly decodes state from_bin/1" do
    bin_state =
      <<153, 0, 33, 1, 0, 30, 0, 51, 1, 3, 0, 24, 1, 0, 10, 22, 2, 64, 86, 0, 0, 0, 0, 0, 0, 2, 0,
        8, 0, 0, 1, 105, 82, 129, 191, 34, 153, 0, 14, 1, 0, 11, 0, 32, 1, 4, 0, 5, 1, 0, 2, 0,
        0>>

    state = VehicleStatusState.from_bin(bin_state)

    assert [diag_state, door_state] = state.states

    assert diag_state.data.speed.data == {88, :miles_per_hour}
    assert diag_state.data.speed.timestamp == DateTime.from_unix!(1_551_867_428_642, :millisecond)
    refute diag_state.data.speed.failure

    assert [position] = door_state.data.positions
    assert position.data.location == :front_left
    assert position.data.position == :closed
    refute position.timestamp
    refute position.failure
  end
end
