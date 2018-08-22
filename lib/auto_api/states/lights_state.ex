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
defmodule AutoApi.LightsState do
  @moduledoc """
  StartStop state
  """

  alias AutoApi.CommonData

  defstruct front_exterior_light: nil,
            rear_exterior_light: nil,
            interior_light: nil,
            ambient_light: %{},
            reverse_light: nil,
            emergency_brake_light: nil,
            timestamp: nil,
            properties: []

  use AutoApi.State, spec_file: "specs/lights.json"

  @type front_exterior_light :: :inactive | :active | :active_with_full_beam
  @type activity :: :inactive | :active
  @type ambient_light :: %{rgb_red: integer, rgb_green: integer, rgb_blue: integer}

  @type t :: %__MODULE__{
          front_exterior_light: front_exterior_light | nil,
          rear_exterior_light: activity | nil,
          interior_light: activity | nil,
          ambient_light: ambient_light | %{},
          reverse_light: activity | nil,
          emergency_brake_light: nil,
          timestamp: DateTime.t() | nil,
          properties: list(atom)
        }

  @doc """
  Build state based on binary value

    iex> AutoApi.LightsState.from_bin(<<0x01, 1::integer-16, 0x00>>)
    %AutoApi.LightsState{front_exterior_light: :inactive}

    iex> AutoApi.LightsState.from_bin(<<0x01, 1::integer-16, 0x02>>)
    %AutoApi.LightsState{front_exterior_light: :active_with_full_beam}

    iex> AutoApi.LightsState.from_bin(<<0x04, 3::integer-16, 0xFF, 0xFF, 0xFF>>)
    %AutoApi.LightsState{ambient_light: %{rgb_green: 0xFF, rgb_red: 0xFF, rgb_blue: 0xFF}}

  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    state = parse_bin_properties(bin, %__MODULE__{})

    ambient_light =
      if is_list(state.ambient_light) do
        List.first(state.ambient_light)
      else
        state.ambient_light
      end

    %{state | ambient_light: ambient_light}
  end

  @doc """
  Parse state to bin
    iex> AutoApi.LightsState.to_bin(%AutoApi.LightsState{front_exterior_light: :active, properties: [:front_exterior_light]})
    <<1, 1::integer-16, 1>>

    iex> AutoApi.LightsState.to_bin(%AutoApi.LightsState{ambient_light: %{rgb_red: 5, rgb_green: 10, rgb_blue: 99}, properties: [:ambient_light]})
    <<4, 3::integer-16, 5, 10, 99>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    state_copy =
      if is_map(state.ambient_light) do
        %{state | ambient_light: [state.ambient_light]}
      else
        state
      end

    parse_state_properties(state_copy)
  end
end
