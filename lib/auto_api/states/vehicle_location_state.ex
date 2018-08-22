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
  Vehicle Location state
  """

  defstruct coordinates: %{}, heading: nil, altitude: nil, timestamp: nil, properties: []

  use AutoApi.State, spec_file: "specs/vehicle_location.json"

  @type t :: %__MODULE__{
          coordinates: list | map,
          heading: float | nil,
          altitude: float | nil,
          timestamp: DateTime.t() | nil,
          properties: list(atom)
        }

  @doc """
  Build state based on binary value

    iex> AutoApi.VehicleLocationState.from_bin(<<0x01, 8::integer-16, 52.520008::float-32, 13.404954::float-32, 0x02, 4::integer-16, 52.520008::float-32>>)
    %AutoApi.VehicleLocationState{coordinates: %{latitude: 52.520008, longitude: 13.404954}, heading: 52.520008}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    state = parse_bin_properties(bin, %__MODULE__{})
    coordinates = List.first(state.coordinates)
    %{state | coordinates: coordinates}
  end

  @doc """
  Parse state to bin
    ie> AutoApi.VehicleLocationState.to_bin(%AutoApi.VehicleLocationState{coordinates: %{latitude: 12.000001, longitude: 13.000002}, heading: 12.00009, properties: [:coordinates, :heading]})
    <<0x01, 8::integer-16, 12.000001::float-32, 13.000002::float-32, 0x02, 4::integer-16, 12.00009::float-32>>

    iex> AutoApi.VehicleLocationState.to_bin(%AutoApi.VehicleLocationState{heading: 12.00009, altitude: 19.0923939, properties: [:coordinates, :heading, :altitude]})
    <<0x03, 4::integer-16, 19.0923939::float-32, 0x02, 4::integer-16, 12.00009::float-32>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    state_copy = %__MODULE__{
      coordinates: [state.coordinates],
      heading: state.heading,
      altitude: state.altitude,
      properties: state.properties
    }

    parse_state_properties(state_copy)
  end
end
