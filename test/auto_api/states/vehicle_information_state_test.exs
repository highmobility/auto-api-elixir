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
defmodule AutoApi.VehicleInformationStateTest do
  use ExUnit.Case, async: true
  doctest AutoApi.VehicleInformationState
  alias AutoApi.{VehicleInformationState, State}

  test "to_bin/1 & from_bin/1" do
    state =
      %VehicleInformationState{}
      |> State.put(:powertrain, data: :all_electric)
      |> State.put(:gearbox, data: :semi_automatic)
      |> State.put(:model_name, data: "HM Concept")
      |> State.put(:equipments, data: "eq 1")
      |> State.put(:equipments, data: "eq 2")
      |> State.put(:engine_volume, data: {750, :cubic_centimeters})

    new_state =
      state
      |> VehicleInformationState.to_bin()
      |> VehicleInformationState.from_bin()

    assert state == new_state
  end
end
