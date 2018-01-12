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
defmodule AutoApi.MaintenanceState do
  defstruct next_service_in_days: nil, next_service_in_km: nil

  use AutoApi.State

  @type t :: %__MODULE__{next_service_in_days: integer, next_service_in_km: integer}

  @spec from_bin(<<_::40>>) :: __MODULE__.t
  def from_bin(<<days::integer-16, km::integer-24>>) do
    struct(__MODULE__, %{next_service_in_days: days, next_service_in_km: km})
  end


  @spec to_bin(__MODULE__.t) :: <<_::40>>
  def to_bin(%__MODULE__{} = state) do
    <<state.next_service_in_days::integer-16, state.next_service_in_km::integer-24>>
  end
end
