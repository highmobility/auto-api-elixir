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
  VehicleLocationState
  """

  alias AutoApi.PropertyComponent

  defstruct coordinates: nil,
            heading: nil,
            altitude: nil,
            timestamp: nil,
            properties: [],
            property_timestamps: %{}

  use AutoApi.State, spec_file: "specs/vehicle_location.json"

  @type coordinates :: %{latitude: float, longitude: float}

  @type t :: %__MODULE__{
          coordinates: %PropertyComponent{data: coordinates} | nil,
          heading: %PropertyComponent{data: float} | nil,
          altitude: %PropertyComponent{data: float} | nil,
          timestamp: DateTime.t() | nil,
          properties: list(atom),
          property_timestamps: map()
        }

  @doc """
  Build state based on binary value

    iex> bin = <<5, 0, 11, 1, 0, 8, 64, 101, 249, 235, 133, 30, 184, 82>>
    iex> AutoApi.VehicleLocationState.from_bin(bin)
    %AutoApi.VehicleLocationState{heading: %AutoApi.PropertyComponent{data: 175.81}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.VehicleLocationState{heading: %AutoApi.PropertyComponent{data: 175.81}, properties: [:heading]}
    iex> AutoApi.VehicleLocationState.to_bin(state)
    <<5, 0, 11, 1, 0, 8, 64, 101, 249, 235, 133, 30, 184, 82>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
