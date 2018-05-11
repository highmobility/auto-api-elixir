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
defmodule AutoApi.TachographState do
  @moduledoc """
  Keeps Tachograph state

  """

  @doc """
  Tachograph state
  """
  defstruct driver_working_state: [],
            driver_time_state: [],
            driver_card: [],
            vehicle_motion: :not_detected,
            vehicle_overspeed: :no_overspeed,
            vehicle_direction: :forward,
            vehicle_speed: 0,
            properties: []

  use AutoApi.State, spec_file: "specs/tachograph.json"

  @type t :: %__MODULE__{
          properties: list(atom)
        }

  @doc """
  Build state based on binary value

    iex> AutoApi.TachographState.from_bin(<<0x06, 1::integer-16, 0x01, 0x07, 2::integer-16, 120::integer-16>>)
    %AutoApi.TachographState{vehicle_direction: :reverse, vehicle_speed: 120}

    iex> AutoApi.TachographState.from_bin(<<0x01, 2::integer-16, 0x95,  0x01>>)
    %AutoApi.TachographState{driver_working_state: [%{driver_number: 149, working_state: :driver_available}]}

  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> properties = [:vehicle_direction, :vehicle_speed]
    iex> AutoApi.TachographState.to_bin(%AutoApi.TachographState{vehicle_speed: 123, vehicle_direction: :forward, properties: properties})
    <<6, 0, 1, 0, 7, 0, 2, 0, 123>>

    iex> properties = AutoApi.TachographCapability.properties |> Enum.into(%{}) |> Map.values()
    iex> AutoApi.TachographState.to_bin(%AutoApi.TachographState{properties: properties})
    <<0x6, 0x0, 0x1, 0x0, 0x4, 0x0, 0x1, 0x0, 0x5, 0x0, 0x1, 0x0, 0x7, 0x0, 0x2, 0x0, 0x0>>

    iex> properties = [:driver_time_state]
    iex> AutoApi.TachographState.to_bin(%AutoApi.TachographState{driver_time_state: [%{driver_number: 9, time_state: :"9_reached"}], properties: properties})
    <<0x02, 0, 2, 0x09, 0x04>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
