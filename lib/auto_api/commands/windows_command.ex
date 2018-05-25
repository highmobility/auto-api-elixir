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
  Handles  commands and apply binary commands on `%AutoApi.WindowsState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.WindowsState
  alias AutoApi.WindowsCapability

  @doc """
  Parses the binary command and makes changes or returns the state

        iex> AutoApi.WindowsCommand.execute(%AutoApi.WindowsState{}, <<0x00>>)
        {:state, %AutoApi.WindowsState{}}

        iex> command = <<0x01>> <> <<0x01, 2::integer-16, 0x01, 0>>
        iex> AutoApi.WindowsCommand.execute(%AutoApi.WindowsState{}, command)
        {:state_changed, %AutoApi.WindowsState{window: [%{window_position: :front_right, window_state: :closed}]}}

        iex> AutoApi.WindowsCommand.execute(%AutoApi.WindowsState{window: [%{window_position: :front_left, window_state: :closed}]}, <<0x02, 0x01, 0x02::integer-16, 0x00, 0x01>>)
        {:state_changed, %AutoApi.WindowsState{window: [%{window_position: :front_left, window_state: :open}]}}

        iex> AutoApi.WindowsCommand.execute(%AutoApi.WindowsState{}, <<0x02, 0x01, 0x02::integer-16, 0x00, 0x01>>)
        {:state, %AutoApi.WindowsState{}}

        iex> AutoApi.WindowsCommand.execute(%AutoApi.WindowsState{window: [%{window_position: :front_right, window_state: :closed}]}, <<0x02, 0x01, 0x02::integer-16, 0x00, 0x01>>)
        {:state, %AutoApi.WindowsState{window: [%{window_position: :front_right, window_state: :closed}]}}
  """
  @spec execute(WindowsState.t(), binary) :: {:state | :state_changed, WindowsState.t()}
  def execute(%WindowsState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%WindowsState{} = state, <<0x01, ds::binary>>) do
    new_state = WindowsState.from_bin(ds)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  def execute(%WindowsState{} = state, <<0x02, commands::binary>>) do
    cmd_result = WindowsState.from_bin(commands)

    window_new_state =
      cmd_result.window
      |> Enum.map(&{&1.window_position, &1.window_state})
      |> Enum.into(%{})

    window_list =
      state.window
      |> Enum.map(fn window_state ->
        if changed_state = Map.get(window_new_state, window_state.window_position) do
          %{window_state | window_state: changed_state}
        else
          window_state
        end
      end)

    new_state = %{state | window: window_list}

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts DoorLocksCommand state to capability's state in binary

        iex> AutoApi.WindowsCommand.state(%AutoApi.WindowsState{window: [%{window_position: :front_right, window_state: :closed}], properties: [:window]})
        <<1, 1, 0, 2, 1, 0>>
  """
  @spec state(WindowsState.t()) :: binary
  def state(%WindowsState{} = state) do
    <<0x01, WindowsState.to_bin(state)::binary>>
  end

  @doc """
  Returns binary command
      iex> AutoApi.WindowsCommand.to_bin(:get_windows_state, [])
      <<0x00>>

      iex> AutoApi.WindowsCommand.to_bin(:open_close_windows, [[%{window_position: :front_right, window_state: :closed}]])
      <<2, 1, 0, 2, 1, 0>>
  """
  @spec to_bin(WindowsCapability.command_type(), list(any)) :: binary
  def to_bin(:get_windows_state = msg, []) do
    cmd_id = WindowsCapability.command_id(msg)
    <<cmd_id>>
  end

  def to_bin(:open_close_windows = msg, [window]) do
    cmd = WindowsState.to_bin(%WindowsState{window: window, properties: [:window]})
    cmd_id = WindowsCapability.command_id(msg)
    <<cmd_id>> <> cmd
  end
end
