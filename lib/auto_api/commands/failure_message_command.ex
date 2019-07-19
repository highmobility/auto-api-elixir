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
  use AutoApi.Command

  alias AutoApi.FailureMessageState
  alias AutoApi.FailureMessageCapability

  @doc """
  Parses the binary command and makes changes or returns the state
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
  """
  @spec state(FailureMessageState.t()) :: binary
  def state(%FailureMessageState{} = state) do
    <<0x01, FailureMessageState.to_bin(state)::binary>>
  end

  @doc """
  Converts command to binary format
  """
  @spec to_bin(FailureMessageCapability.command_type(), list(any())) :: binary
  def to_bin(:failure, opts) do
    state = Enum.into(opts, %{})

    state =
      %FailureMessageState{}
      |> Map.merge(state)

    cmd_id = FailureMessageCapability.command_id(:failure)
    <<cmd_id>> <> FailureMessageState.to_bin(state)
  end
end
