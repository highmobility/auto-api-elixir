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
defmodule AutoApi.HoodState do
  @moduledoc """
  Keeps Hood state
  """

  @type position :: :closed | :open | :intermediate

  @doc """
  Hood state
  """
  defstruct position: nil,
            timestamp: nil,
            properties: []

  use AutoApi.State, spec_file: "specs/hood.json"

  @type t :: %__MODULE__{
          position: position | nil,
          timestamp: DateTime.t() | nil,
          properties: list(atom)
        }

  @doc """
  Build state based on binary value

    iex> AutoApi.HoodState.from_bin(<<0x01, 1::integer-16, 1>>)
    %AutoApi.HoodState{position: :open}

    iex> AutoApi.HoodState.from_bin(<<0x01, 1::integer-16, 0x02>>)
    %AutoApi.HoodState{position: :intermediate}

  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> properties = [:position]
    iex> AutoApi.HoodState.to_bin(%AutoApi.HoodState{position: :closed, properties: properties})
    <<0x01, 1::integer-16, 0x00>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
