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
defmodule AutoApi.WindowsState do
  @moduledoc """
  Keeps Windows state
  """

  @doc """
  Windows state
  """
  defstruct windows_open_percentages: [],
            windows_positions: [],
            timestamp: nil,
            properties: []

  use AutoApi.State, spec_file: "specs/windows.json"

  @type location :: :front_left | :front_right | :rear_left | :rear_right | :hatch

  @type position :: :closed | :opened | :intermediate

  @type windows_open_percentages :: %{
          window_location: location,
          open_percentage: integer
        }

  @type windows_positions :: %{
          window_location: location,
          window_position: position
        }

  @type t :: %__MODULE__{
          windows_open_percentages: list(windows_open_percentages) | nil,
          windows_positions: list(windows_positions) | nil,
          timestamp: DateTime.t() | nil,
          properties: list(atom)
        }

  @doc """
  Build state based on binary value

  ## Examples

        iex> AutoApi.WindowsState.from_bin(<<0x02, 2::integer-16, 4, 0x2A>>)
        %AutoApi.WindowsState{windows_open_percentages: [%{window_location: :hatch, open_percentage: 42}]}

        iex> AutoApi.WindowsState.from_bin(<<0x03, 2::integer-16, 1, 1>>)
        %AutoApi.WindowsState{windows_positions: [%{window_location: :front_right, window_position: :opened}]}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

  ## Examples

      iex> properties = [:windows_open_percentages]
      iex> percentages = [%{window_location: :hatch, open_percentage: 42}]
      iex> state = %AutoApi.WindowsState{windows_open_percentages: percentages, properties: properties}
      iex> AutoApi.WindowsState.to_bin(state)
      <<0x02, 2::integer-16, 4, 0x2A>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
