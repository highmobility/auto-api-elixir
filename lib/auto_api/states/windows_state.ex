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
  Windows state
  """

  alias AutoApi.CommonData
  defstruct window: [], properties: []

  use AutoApi.State, spec_file: "specs/windows.json"

  @type window_position :: :front_left | :front_right | :rear_right | :rear_left | :hatch
  @type window_state :: :closed | :open
  @type window :: %{window_position: window_position, window_state: window_state}

  @type t :: %__MODULE__{
          window: list(window),
          properties: list(atom)
        }

  @doc """
  Build state based on binary value

    iex> AutoApi.WindowsState.from_bin(<<0x01, 2::integer-16, 0x00, 0x00>>)
    %AutoApi.WindowsState{window: [%{window_position: :front_left, window_state: :closed}]}

    iex> AutoApi.WindowsState.from_bin(<<0x01, 2::integer-16, 0x00, 0x01, 0x01, 2::integer-16, 0x01, 0x00>>)
    %AutoApi.WindowsState{window: [%{window_position: :front_right, window_state: :closed}, %{window_position: :front_left, window_state: :open}]}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin
    iex> AutoApi.WindowsState.to_bin(%AutoApi.WindowsState{})
    <<>>

    iex> AutoApi.WindowsState.to_bin(%AutoApi.WindowsState{window: [%{window_position: :front_right, window_state: :closed}], properties: [:window]})
    <<1, 0, 2, 1, 0>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
