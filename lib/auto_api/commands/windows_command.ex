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
defmodule AutoApi.WindowsCommand do
  @moduledoc """
  Handles Windows commands and apply binary commands on `%AutoApi.WindowsState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.WindowsState
  alias AutoApi.WindowsCapability

  @doc """
  Parses the binary command and makes changes or returns the state

  ## Examples

        iex> AutoApi.WindowsCommand.execute(%AutoApi.WindowsState{}, <<0x00>>)
        {:state, %AutoApi.WindowsState{}}

        iex> command = <<0x01>> <> <<0x02, 2::integer-16, 4, 0x2A>> <> <<0x03, 2::integer-16, 1, 1>>
        iex> AutoApi.WindowsCommand.execute(%AutoApi.WindowsState{}, command)
        {:state_changed, %AutoApi.WindowsState{windows_open_percentages: [%{window_location: :hatch, open_percentage: 42}], windows_positions: [%{window_location: :front_right, window_position: :opened}]}}
  """
  @spec execute(WindowsState.t(), binary) :: {:state | :state_changed, WindowsState.t()}
  def execute(%WindowsState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%WindowsState{} = state, <<0x01, ws::binary>>) do
    new_state = WindowsState.from_bin(ws)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  def execute(%WindowsState{} = _state, <<0x12, _payload::binary>>) do
    # TODO
    raise "Not implemented!"
  end

  @doc """
  Converts a WindowsCommand state to capability's state in binary

  ## Examples

      iex> properties = [:windows_open_percentages]
      iex> percentages = [%{window_location: :hatch, open_percentage: 42}]
      iex> state = %AutoApi.WindowsState{windows_open_percentages: percentages, properties: properties}
      iex> AutoApi.WindowsCommand.state(state)
      <<0x01, 0x02, 2::integer-16, 4, 0x2A>>
  """
  @spec state(WindowsState.t()) :: binary
  def state(%WindowsState{} = state) do
    <<0x01, WindowsState.to_bin(state)::binary>>
  end

  @doc """
  Converts a command to binary format

  ## Examples

        iex> AutoApi.WindowsCommand.to_bin(:get_windows_state, [])
        <<0x00>>
  """
  @spec to_bin(WindowsCapability.command_type(), list(any())) :: binary
  def to_bin(:get_windows_state, []) do
    cmd_id = WindowsCapability.command_id(:get_windows_state)
    <<cmd_id>>
  end

  def to_bin(:control_windows, _args) do
    # TODO
    raise "Not implemented!"
  end
end
