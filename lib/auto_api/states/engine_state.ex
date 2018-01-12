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
  alias AutoApi.CommonData

  defstruct engine: nil

  use AutoApi.State

  @type t :: %__MODULE__{engine: CommonData.electricity}

  @spec from_bin(integer) :: t
  def from_bin(engine_status) when is_integer(engine_status) do
    %__MODULE__{engine: CommonData.bin_electricity_to_atom(engine_status)}
  end

  @spec to_bin(t) :: integer
  def to_bin(%__MODULE__{} = state) do
    CommonData.atom_electricity_to_bin(state.engine)
  end
end
