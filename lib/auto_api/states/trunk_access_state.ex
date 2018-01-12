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
defmodule AutoApi.TrunkAccessState do
  alias AutoApi.CommonData

  defstruct lock: nil, position: nil

  use AutoApi.State

  @type t :: %__MODULE__{lock: CommonData.lock, position: CommonData.position}

  @spec from_bin(binary) :: t
  def from_bin(<<lock, position>>) do
    %__MODULE__{lock: CommonData.bin_lock_to_atom(lock), position: CommonData.bin_position_to_atom(position)}
  end

  @spec to_bin(t) :: <<_::16>>
  def to_bin(%__MODULE__{} = state) do
    <<CommonData.atom_lock_to_bin(state.lock), CommonData.atom_position_to_bin(state.position)>>
  end
end
