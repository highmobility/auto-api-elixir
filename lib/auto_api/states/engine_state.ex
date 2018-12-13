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
defmodule AutoApi.EngineState do
  @moduledoc """
  Keeps Engine state
  """

  @type ignition :: :ignition_on | :ignition_off
  @type accessories_ignition :: :powered_on | :powered_off

  @type t :: %__MODULE__{
          ignition: ignition | nil,
          accessories_ignition: accessories_ignition | nil,
          properties: list(atom),
          property_timestamps: map
        }

  @doc """
  Engine state
  """
  defstruct ignition: nil,
            accessories_ignition: nil,
            properties: [],
            property_timestamps: %{}

  use AutoApi.State, spec_file: "specs/engine.json"

  @doc """
  Build state based on binary value

    iex> AutoApi.EngineState.from_bin(<<0x02, 1::integer-16, 0x01>>)
    %AutoApi.EngineState{accessories_ignition: :powered_on}

    iex> AutoApi.EngineState.from_bin(<<0x02, 1::integer-16, 0x00, 0x01, 1::integer-16, 0x01>>)
    %AutoApi.EngineState{accessories_ignition: :powered_off, ignition: :ignition_on}

  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> properties = [:accessories_ignition, :ignition]
    iex> AutoApi.EngineState.to_bin(%AutoApi.EngineState{accessories_ignition: :powered_on, ignition: :ignition_off, properties: properties})
    <<0x02, 1::integer-16, 0x01, 0x01, 1::integer-16, 0x00>>

    iex> AutoApi.EngineState.to_bin(%AutoApi.EngineState{ignition: :ignition_on, properties: [:ignition]})
    <<0x01, 1::integer-16, 0x01>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
