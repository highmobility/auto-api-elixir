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

  alias AutoApi.PropertyComponent

  @doc """
  Windows state
  """
  defstruct windows_open_percentages: [],
            windows_positions: [],
            timestamp: nil

  use AutoApi.State, spec_file: "specs/windows.json"

  @type location :: :front_left | :front_right | :rear_left | :rear_right | :hatch
  @type position :: :closed | :open | :intermediate
  @type window_position :: %PropertyComponent{
          data: %{window_location: location, window_position: position}
        }
  @type window_open_percentage :: %PropertyComponent{
          data: %{window_location: location, open_percentage: float}
        }

  @type t :: %__MODULE__{
          windows_open_percentages: list(window_open_percentage),
          windows_positions: list(window_position),
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<2, 0, 12, 1, 0, 9, 4, 63, 199, 10, 61, 112, 163, 215, 10>>
    iex> AutoApi.WindowsState.from_bin(bin)
    %AutoApi.WindowsState{windows_open_percentages: [%AutoApi.PropertyComponent{data: %{window_location: :hatch, open_percentage: 0.18}}]}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.WindowsState{windows_open_percentages: [%AutoApi.PropertyComponent{data: %{window_location: :hatch, open_percentage: 0.18}}]}
    iex> AutoApi.WindowsState.to_bin(state)
    <<2, 0, 12, 1, 0, 9, 4, 63, 199, 10, 61, 112, 163, 215, 10>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
