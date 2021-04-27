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
defmodule AutoApiL12.MultiCommandStateTest do
  use ExUnit.Case, async: true
  use PropCheck
  import AutoApiL12.PropCheckFixtures

  doctest AutoApiL12.MultiCommandState

  property "to_bin/1 and from_bin/1 are inverse" do
    forall data <- [multi_states: list(command()), multi_commands: list(command())] do
      state = %AutoApiL12.MultiCommandState{
        multi_states: wrap_in_property_data(data[:multi_states]),
        multi_commands: wrap_in_property_data(data[:multi_commands])
      }

      assert state_bin = AutoApiL12.MultiCommandState.to_bin(state)
      assert state == AutoApiL12.MultiCommandState.from_bin(state_bin)
    end
  end

  defp wrap_in_property_data(items) do
    for item <- items, do: %AutoApiL12.Property{data: item}
  end
end
