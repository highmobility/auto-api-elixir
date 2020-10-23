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
defmodule AutoApi.VehicleLocationStateTest do
  use ExUnit.Case, async: true
  doctest AutoApi.VehicleLocationState
  alias AutoApi.VehicleLocationState

  test "to_bin/1 & from_bin" do
    state =
      %VehicleLocationState{}
      |> VehicleLocationState.put_property(:altitude, {133.5, :meters})
      |> VehicleLocationState.put_property(:heading, {0.5, :degrees})
      |> VehicleLocationState.put_property(:coordinates, %{
        latitude: 52.516506,
        longitude: 13.381815
      })

    new_state =
      state
      |> VehicleLocationState.to_bin()
      |> VehicleLocationState.from_bin()

    assert new_state == state
  end
end
