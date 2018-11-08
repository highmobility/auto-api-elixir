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
defmodule AutoApi.FailureMessageCommand do
  @moduledoc """
  Handles FailureMessage commands and apply binary commands on `%AutoApi.FailureMessageState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.FailureMessageState
  alias AutoApi.FailureMessageCapability

  @doc """
  Parses the binary command and makes changes or returns the state

        iex> cmd = <<0x01, 2::integer-16, 0x00, 0x21>>
        iex> cmd = cmd <> <<0x02, 1::integer-16, 0x00>>
        iex> cmd = cmd <> <<0x03, 1::integer-16, 0x03>>
        iex> cmd = cmd <> <<0x04, 3::integer-16>> <> "boo"
        iex> AutoApi.FailureMessageCommand.execute(%AutoApi.FailureMessageState{}, <<0x01>> <> cmd)
        {:state_changed, %AutoApi.FailureMessageState{failure_reason: :execution_timeout, failure_description: "boo", failed_message_identifier: 33 ,failed_message_type: 0}}

  """
  def execute(%FailureMessageState{} = state, <<0x01, ds::binary>>) do
    new_state = FailureMessageState.from_bin(ds)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts AutoApi.FailureMessageCommand state to capability's state in binary

        iex> properties = [:failure_reason]
        iex> AutoApi.FailureMessageCommand.state(%AutoApi.FailureMessageState{failure_reason: :incorrect_state, properties: properties})
        <<1, 3, 0, 1, 2>>
  """
  @spec state(FailureMessageState.t()) :: binary
  def state(%FailureMessageState{} = state) do
    <<0x01, FailureMessageState.to_bin(state)::binary>>
  end

  @doc """
  Converts command to binary format

      iex> opts = [failed_message_identifier: 2, failed_message_type: 1, failure_reason: :unauthorized]
      iex> AutoApi.FailureMessageCommand.to_bin(:failure, opts)
      <<0x01>> <> <<1, 0, 2, 0, 2, 2, 0, 1, 1, 3, 0, 1, 1>>
  """
  @spec to_bin(FailureMessageCapability.command_type(), list(any())) :: binary
  def to_bin(:failure, opts) do
    state = Enum.into(opts, %{})

    state =
      %FailureMessageState{}
      |> Map.merge(state)
      |> Map.put(:properties, Keyword.keys(opts))

    cmd_id = FailureMessageCapability.command_id(:failure)
    <<cmd_id>> <> FailureMessageState.to_bin(state)
  end
end
