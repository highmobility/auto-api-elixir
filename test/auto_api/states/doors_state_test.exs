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
defmodule AutoApiL12.DoorsStateTest do
  use ExUnit.Case, async: true
  doctest AutoApiL12.DoorsState
  alias AutoApiL12.{DoorsState, State}

  test "to_bin & from_bin" do
    state =
      %DoorsState{}
      |> State.put(:positions,
        data: %{
          location: :front_left,
          position: :closed
        }
      )
      |> State.put(:positions,
        data: %{
          location: :front_right,
          position: :open
        }
      )
      |> State.put(:inside_locks,
        data: %{
          location: :front_right,
          lock_state: :unlocked
        }
      )
      |> State.put(:locks,
        data: %{
          location: :front_right,
          lock_state: :unlocked
        }
      )

    new_state =
      state
      |> DoorsState.to_bin()
      |> DoorsState.from_bin()

    assert state == new_state
  end
end
