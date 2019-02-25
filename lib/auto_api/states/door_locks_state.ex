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

  alias AutoApi.{CommonData, PropertyComponent}

  defstruct inside_locks: [],
            locks: [],
            positions: [],
            timestamp: nil

  use AutoApi.State, spec_file: "specs/door_locks.json"

  @type lock :: %PropertyComponent{
          data: %{
            door_location: CommonData.location(),
            lock_state: CommonData.lock()
          }
        }

  @type inside_lock :: %PropertyComponent{
          data: %{
            door_location: CommonData.location(),
            lock_state: CommonData.lock()
          }
        }

  @type position :: %PropertyComponent{
          data: %{
            door_location: CommonData.location(),
            position: CommonData.position()
          }
        }

  @type t :: %__MODULE__{
          locks: list(lock),
          inside_locks: list(inside_lock),
          positions: list(position),
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> AutoApi.DoorLocksState.from_bin(<<0x03, 2::integer-16, 0x00, 0x01>>)
    %AutoApi.DoorLocksState{locks: [%{door_location: :front_left, lock_state: :locked}]}

    iex> AutoApi.DoorLocksState.from_bin(<<0x03, 2::integer-16, 0x05, 0x01>>)
    %AutoApi.DoorLocksState{locks: [%{door_location: :all, lock_state: :locked}]}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin
    iex> AutoApi.DoorLocksState.to_bin(%AutoApi.DoorLocksState{positions: [%{door_location: :front_left, position: :open}], properties: [:positions]})
    <<0x04, 2::integer-16, 0x00, 0x01>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
