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
defmodule AutoApi.VehicleTimeState do
  @moduledoc """
  VehicleTime state
  """

  alias AutoApi.CommonData

  defstruct vehicle_time: %{}, properties: []

  use AutoApi.State, spec_file: "specs/vehicle_time.json"

  @type vehicle_time :: %{
          year: integer,
          month: integer,
          day: integer,
          hour: integer,
          minute: integer,
          second: integer,
          utc_time_offset: integer
        }

  @type t :: %__MODULE__{
          vehicle_time: list(vehicle_time) | vehicle_time
        }

  @doc """
  Build state based on binary value

    iex> AutoApi.VehicleTimeState.from_bin(<<0x01, 8::integer-16, 94, 12, 1, 12, 0, 59, -30::integer-signed-16>>)
    %AutoApi.VehicleTimeState{vehicle_time: %{year: 94, month: 12, day: 1, hour: 12, minute: 0, second: 59, utc_time_offset: 65506}}

    iex> AutoApi.VehicleTimeState.from_bin(<<0x01, 8::integer-16, 94, 12, 1, 12, 0, 59, 30::integer-16>>)
    %AutoApi.VehicleTimeState{vehicle_time: %{year: 94, month: 12, day: 1, hour: 12, minute: 0, second: 59, utc_time_offset: 30}}

  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    state = parse_bin_properties(bin, %__MODULE__{})
    vehicle_time = List.first(state.vehicle_time)
    %{state | vehicle_time: vehicle_time}
  end

  @doc """
  Parse state to bin
    iex> vehicle_time = %{year: 94, month: 12, day: 1, hour: 12, minute: 0, second: 59, utc_time_offset: 65506}
    iex> AutoApi.VehicleTimeState.to_bin(%AutoApi.VehicleTimeState{vehicle_time: vehicle_time, properties: [:vehicle_time]})
    <<0x01, 8::integer-16, 94, 12, 1, 12, 0, 59, -30::integer-signed-16>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    state_copy = %__MODULE__{
      vehicle_time: [state.vehicle_time],
      properties: state.properties
    }

    parse_state_properties(state_copy)
  end
end
