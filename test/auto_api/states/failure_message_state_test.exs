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
defmodule AutoApi.FailureMessageStateTest do
  use ExUnit.Case
  alias AutoApi.FailureMessageState

  test "to_bin & from_bin" do
    state =
      %FailureMessageState{}
      |> FailureMessageState.put_property(:failed_message_identifier, 0x35)
      |> FailureMessageState.put_property(:failed_message_type, 0x00)
      |> FailureMessageState.put_property(:failure_reason, :unauthorized)
      |> FailureMessageState.put_property(
        :failure_description,
        "Access to this capability was not granted"
      )

    new_state =
      state
      |> FailureMessageState.to_bin()
      |> FailureMessageState.from_bin()

    assert new_state == state
  end
end
