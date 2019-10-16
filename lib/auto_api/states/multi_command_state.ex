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
defmodule AutoApi.MultiCommandState do
  @moduledoc """
  MultiCommand state
  """

  alias AutoApi.{CommonData, PropertyComponent}

  defstruct multi_states: [],
            multi_commands: [],
            timestamp: nil

  use AutoApi.State, spec_file: "specs/multi_command.json"

  @type t :: %__MODULE__{
          multi_states: list(%PropertyComponent{}),
          multi_commands: list(%PropertyComponent{}),
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> AutoApi.MultiCommandState.from_bin(<<1, 0, 13, 1, 0, 10, 0, 103, 1, 1, 0, 4, 1, 0, 1, 0>>)
    %AutoApi.MultiCommandState{multi_states: [%AutoApi.PropertyComponent{data: %AutoApi.HoodState{position: %AutoApi.PropertyComponent{data: :closed}}}]}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.PropertyComponent{data: %AutoApi.HoodState{position: %AutoApi.PropertyComponent{data: :closed}}}
    iex> AutoApi.MultiCommandState.to_bin(%AutoApi.MultiCommandState{multi_states: [state]})
    <<1, 0, 13, 1, 0, 10, 0, 103, 1, 1, 0, 4, 1, 0, 1, 0>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
