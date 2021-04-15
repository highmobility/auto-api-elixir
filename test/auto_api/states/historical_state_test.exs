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
defmodule AutoApi.HistoricalStateTest do
  use ExUnit.Case, async: true
  doctest AutoApi.HistoricalState

  alias AutoApi.{ChargingState, HistoricalState, Property, SetCommand}

  test "from_bin/1 and to_bin/1" do
    states = [
      %Property{
        data: SetCommand.new(%ChargingState{battery_level: %Property{data: 0.6}}),
        timestamp: ~U[2019-10-16 12:34:04.000Z]
      },
      %Property{
        data: SetCommand.new(%ChargingState{battery_level: %Property{data: 0.75}}),
        timestamp: ~U[2019-10-16 13:34:04.000Z]
      },
      %Property{
        data: SetCommand.new(%ChargingState{battery_level: %Property{data: 0.89}}),
        timestamp: ~U[2019-10-16 14:34:04.000Z]
      }
    ]

    state = %HistoricalState{
      states: states,
      capability_id: %Property{data: 35},
      start_date: %Property{data: ~U[2019-10-16 12:34:04.000Z]},
      end_date: %Property{data: ~U[2019-10-16 14:34:04.000Z]}
    }

    restored_state =
      state
      |> HistoricalState.to_bin()
      |> HistoricalState.from_bin()

    assert restored_state == state
  end
end
