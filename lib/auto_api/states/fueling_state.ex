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
defmodule AutoApi.FuelingState do
  @moduledoc """
  Fueling state
  """

  alias AutoApi.CommonData
  defstruct gas_flap_position: nil, gas_flap_lock: nil, timestamp: nil, properties: []

  use AutoApi.State, spec_file: "specs/fueling.json"

  @type t :: %__MODULE__{
          gas_flap_position: CommonData.position() | nil,
          gas_flap_lock: CommonData.lock() | nil,
          timestamp: DateTime.t() | nil,
          properties: list(atom)
        }

  @doc """
  Build state based on binary value

    iex> AutoApi.FuelingState.from_bin(<<0x03, 1::integer-16, 0x00, 0x02, 1::integer-16, 0x00>>)
    %AutoApi.FuelingState{gas_flap_position: :closed, gas_flap_lock: :unlocked}

    iex> AutoApi.FuelingState.from_bin(<<0x03, 1::integer-16, 0x01>>)
    %AutoApi.FuelingState{gas_flap_position: :open}

  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin
    iex> AutoApi.FuelingState.to_bin(%AutoApi.FuelingState{properties: [:gas_flap_position]})
    <<>>

    iex> AutoApi.FuelingState.to_bin(%AutoApi.FuelingState{gas_flap_position: :closed, properties: [:gas_flap_position]})
    <<3, 1::integer-16, 0>>

    iex> AutoApi.FuelingState.to_bin(%AutoApi.FuelingState{gas_flap_position: :open, properties: [:gas_flap_position]})
    <<3, 1::integer-16, 1>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
