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

  alias AutoApi.{CommonData, PropertyComponent}

  @doc """
  Navigation destination state
  """
  defstruct coordinates: nil,
            destination_name: nil,
            data_slots_free: nil,
            data_slots_max: nil,
            arrival_duration: nil,
            distance_to_destination: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "specs/navi_destination.json"

  @type t :: %__MODULE__{
          coordinates: %PropertyComponent{data: CommonData.coordinates()} | nil,
          destination_name: %PropertyComponent{data: String.t()} | nil,
          data_slots_free: %PropertyComponent{data: integer} | nil,
          data_slots_max: %PropertyComponent{data: integer} | nil,
          arrival_duration: %PropertyComponent{data: CommonData.time()} | nil,
          distance_to_destination: %PropertyComponent{data: integer} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<2, 0, 7, 1, 0, 4, 72, 111, 109, 101>>
    iex> AutoApi.NaviDestinationState.from_bin(bin)
    %AutoApi.NaviDestinationState{destination_name: %AutoApi.PropertyComponent{data: "Home"}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.NaviDestinationState{destination_name: %AutoApi.PropertyComponent{data: "Home"}}
    iex> AutoApi.NaviDestinationState.to_bin(state)
    <<2, 0, 7, 1, 0, 4, 72, 111, 109, 101>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
