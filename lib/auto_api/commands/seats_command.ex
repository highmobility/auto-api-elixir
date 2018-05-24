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
defmodule AutoApi.SeatsCommand do
  @moduledoc """
  Handles  commands and apply binary commands on `%AutoApi.SeatsState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.SeatsState
  alias AutoApi.SeatsCapability

  @doc """
  Parses the binary command and makes changes or returns the state

        iex> AutoApi.SeatsCommand.execute(%AutoApi.SeatsState{}, <<0x00>>)
        {:state, %AutoApi.SeatsState{}}

        iex> command = <<0x01>> <> <<0x01, 3::integer-16, 0x01, 0x01, 0x01>>
        iex> AutoApi.SeatsCommand.execute(%AutoApi.SeatsState{}, command)
        {:state_changed, %AutoApi.SeatsState{seat: [%{person_detected: :detected, seat_position: :front_right, seatbelt_fastened: :fastened}]}}
  """
  @spec execute(SeatsState.t(), binary) :: {:state | :state_changed, SeatsState.t()}
  def execute(%SeatsState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%SeatsState{} = state, <<0x01, ds::binary>>) do
    new_state = SeatsState.from_bin(ds)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts DoorLocksCommand state to capability's state in binary

        iex> seat = [%{person_detected: :detected, seat_position: :front_right, seatbelt_fastened: :fastened}]
        iex> AutoApi.SeatsCommand.state(%AutoApi.SeatsState{seat: seat, properties: [:seat]})
        <<1, 1, 0, 3, 1, 1, 1>>
  """
  @spec state(SeatsState.t()) :: binary
  def state(%SeatsState{} = state) do
    <<0x01, SeatsState.to_bin(state)::binary>>
  end

  @doc """
  Returns binary command
      iex> AutoApi.SeatsCommand.to_bin(:get_seats_state, [])
      <<0x00>>

  """
  @spec to_bin(SeatsCapability.command_type(), list(any)) :: binary
  def to_bin(:get_seats_state = msg, _args) do
    cmd_id = SeatsCapability.command_id(msg)
    <<cmd_id>>
  end
end
