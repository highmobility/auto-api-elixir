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
defmodule AutoApi.DoorLockState do
  defstruct location: nil, position: nil, lock: nil

  alias AutoApi.CommonData

  @type t :: %AutoApi.DoorLockState{location: CommonData.location, position: CommonData.position, lock: CommonData.lock}
end

defmodule AutoApi.DoorLocksState do
  @moduledoc """
  Door position possible values: :closed, :open
  Door lock possible values: :unlocked, :locked
  """
  defstruct doors: []

  use AutoApi.State

  alias AutoApi.CommonData

  @doors_unlock_cmd 0x00
  @doors_lock_cmd 0x01

  @type position :: :closed | :open
  @type lock :: :unlocked | :locked

  @type t :: %AutoApi.DoorLocksState{doors: list(AutoApi.DoorLockState.t)}

  @spec from_bin(binary) :: AutoApi.DoorLocksState.t
  def from_bin(<<doors::binary>>) do
    door_list =
      doors
      |> :binary.bin_to_list
      |> Enum.chunk_every(3)
      |> Enum.map(fn [loc, pos, lock] ->
        %AutoApi.DoorLockState{location: CommonData.bin_location_to_atom(loc), position: CommonData.bin_position_to_atom(pos), lock: CommonData.bin_lock_to_atom(lock)}
      end)

    %__MODULE__{doors: door_list}
  end

  @spec to_bin(AutoApi.DoorLocksState.t) :: binary
  def to_bin(%__MODULE__{} = state) do
    resp =
      state.doors
      |> Enum.map(fn %{location: location, lock: lock, position: position} ->
        loc = CommonData.atom_location_to_bin(location)
        pos = CommonData.atom_position_to_bin(position)
        lock = CommonData.atom_lock_to_bin(lock)
        <<loc, pos, lock>>
      end)

    <<length(resp)>> <> Enum.reduce(resp, <<>>, fn x , acc -> x <> acc end)
  end

  @spec change_locks_status(AutoApi.DoorLocksState.t, integer) :: AutoApi.DoorLocksState.t
  def change_locks_status(%__MODULE__{} = state, @doors_unlock_cmd) do
    doors =
      state.doors
      |> Enum.map(fn d -> %{d | lock: :unlocked} end)
    %{state | doors: doors}
  end

  def change_locks_status(%__MODULE__{} = state, @doors_lock_cmd) do
    doors =
      state.doors
      |> Enum.map(fn d -> %{d | lock: :locked} end)
    %{state | doors: doors}
  end
end
