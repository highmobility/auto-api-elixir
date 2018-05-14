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
defmodule AutoApi.TrunkState do
  @moduledoc """
  Trunk state
  """

  alias AutoApi.CommonData
  defstruct trunk_lock: :locked, trunk_position: :closed, properties: []

  use AutoApi.State, spec_file: "specs/trunk.json"

  @type t :: %__MODULE__{
          trunk_lock: CommonData.lock(),
          trunk_position: CommonData.position(),
          properties: list(atom)
        }

  @doc """
  Build state based on binary value

    iex> AutoApi.TrunkState.from_bin(<<0x01, 1::integer-16, 0x00, 0x02, 1::integer-16, 0x01>>)
    %AutoApi.TrunkState{trunk_lock: :unlocked, trunk_position: :open}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin
    iex> AutoApi.TrunkState.to_bin(%AutoApi.TrunkState{properties: [:trunk_lock, :trunk_position]})
    <<1, 1::integer-16, 1, 2, 1::integer-16, 0>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
