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
defmodule AutoApi.DoorLocksState do
  @moduledoc """
  Door position possible values: :closed, :open
  Door lock possible values: :unlocked, :locked
  """

  alias AutoApi.CommonData
  defstruct door: [], inside_door_lock: [], outside_door_lock: [], timestamp: nil, properties: []

  use AutoApi.State, spec_file: "specs/door_locks.json"

  @type door :: %{
          door_location: CommonData.location(),
          door_position: CommonData.position(),
          door_lock: CommonData.lock()
        }

  @type inside_door_lock :: %{
          door_location: CommonData.location(),
          inside_lock: CommonData.lock()
        }

  @type outside_lock :: %{
          door_location: CommonData.location(),
          outside_lock: CommonData.lock()
        }

  @type t :: %__MODULE__{
          door: list(door),
          inside_door_lock: list(inside_door_lock),
          outside_door_lock: list(outside_lock),
          timestamp: DateTime.t(),
          properties: list(atom)
        }

  @doc """
  Build state based on binary value

    iex> AutoApi.DoorLocksState.from_bin(<<0x01, 3::integer-16, 0x00, 0x01, 0x00>>)
    %AutoApi.DoorLocksState{door: [%{door_location: :front_left, door_lock: :unlocked, door_position: :open}]}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin
    iex> AutoApi.DoorLocksState.to_bin(%AutoApi.DoorLocksState{door: [%{door_location: :front_left, door_lock: :unlocked, door_position: :open}], properties: [:door]})
    <<0x01, 3::integer-16, 0x00, 0x01, 0x00>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
