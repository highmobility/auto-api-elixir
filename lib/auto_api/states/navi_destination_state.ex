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
defmodule AutoApi.NaviDestinationState do
  @moduledoc """
  Keeps Navigation Destination state
  """

  @type fluid_level :: :low | :filled
  @type position :: :front_left | :front_right | :rear_right | :rear_left
  @type tire_data :: %{position: position, pressure: float}
  @doc """
  Navigation destination state
  """
  defstruct coordinates: nil,
            destination_name: nil,
            timestamp: nil,
            properties: []

  use AutoApi.State, spec_file: "specs/navi_destination.json"

  @type t :: %__MODULE__{
          coordinates: map | nil,
          destination_name: String.t() | nil,
          timestamp: DateTime.t() | nil,
          properties: list(atom)
        }

  @doc """
  Build state based on binary value

    ix> AutoApi.NaviDestinationState.from_bin(<<0x01, 8::integer-16, 52.520008::float-32, 13.404954::float-32, 0x02, 5::integer-16>> <> "hello")
    %AutoApi.NaviDestinationState{coordinates: %{latitude: 52.520008, longitude: 13.404954}, destination_name: "hello"}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin
    ix> AutoApi.NaviDestinationState.to_bin(%AutoApi.NaviDestinationState{coordinates: %{latitude: 12.000001, longitude: 13.000002}, destination_name: "hello", properties: [:coordinates, :destination_name]})
    <<0x01, 8::integer-16, 12.000001::float-32, 13.000002::float-32, 0x02, 5::integer-16, 104, 101, 108, 108, 111>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
