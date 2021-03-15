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
defmodule AutoApi.FailureMessageStateTest do
  use ExUnit.Case, async: true
  use PropCheck

  import AutoApi.PropCheckFixtures
  alias AutoApi.{FailureMessageState, State}

  doctest AutoApi.FailureMessageState

  property "from_command/1" do
    reason_spec = AutoApi.FailureMessageCapability.property_spec(:failure_reason)

    forall data <- [command: command(), reason: enum(reason_spec), desc: utf8()] do
      state = FailureMessageState.from_command(data[:command], data[:reason], data[:desc])

      <<cap_id::integer-16>> = data[:command].capability.identifier()
      assert state.failed_message_id.data == cap_id
      assert state.failed_message_type.data == AutoApi.Command.identifier(data[:command])
      assert state.failure_reason.data == data[:reason]
      assert state.failure_description.data == data[:desc]

      new_state =
        state
        |> FailureMessageState.to_bin()
        |> FailureMessageState.from_bin()

      assert new_state == state
    end
  end

  test "to_bin & from_bin" do
    state =
      %FailureMessageState{}
      |> State.put(:failed_message_id, data: 0x35)
      |> State.put(:failed_message_type, data: 0x00)
      #      |> State.put(:failure_reason, data: :unauthorized)
      |> State.put(:failure_reason, data: :unauthorised)
      |> State.put(
        :failure_description,
        data: "Access to this capability was not granted"
      )

    new_state =
      state
      |> FailureMessageState.to_bin()
      |> FailureMessageState.from_bin()

    assert new_state == state
  end
end
