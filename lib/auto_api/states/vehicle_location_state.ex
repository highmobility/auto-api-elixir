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
defmodule AutoApi.VehicleLocationState do
  @moduledoc """
  The Latitude and Longitude are in 4-bytes per IEEE 754 format
  """
  defstruct latitude: 0, longitude: 0

  use AutoApi.State

  @type t :: %__MODULE__{latitude: float, longitude: float}

  @spec from_bin(<<_::64>>) :: __MODULE__.t
  def from_bin(<<latitude::float-32, longitude::float-32>>) do
    struct(__MODULE__, %{latitude: latitude, longitude: longitude})
  end


  @spec to_bin(__MODULE__.t) :: <<_::64>>
  def to_bin(%__MODULE__{} = state) do
    <<state.latitude::float-32, state.longitude::float-32>>
  end
end
