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
defmodule AutoApi.WindscreenState do
  @moduledoc """
  Windscreen state
  """

  alias AutoApi.{CommonData, PropertyComponent}

  defstruct wipers: nil,
            wipers_intensity: nil,
            windscreen_damage: nil,
            windscreen_zone_matrix: nil,
            windscreen_damage_zone: nil,
            windscreen_needs_replacement: nil,
            windscreen_damage_confidence: nil,
            windscreen_damage_detection_time: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "specs/windscreen.json"

  @type wipers :: :inactive | :active | :automatic
  @type wipers_intensity :: :level_0 | :level_1 | :level_2 | :level_3
  @type windscreen_damage ::
          :no_impact_detected
          | :impact_but_no_damage_detected
          | :damage_smaller_than_1_inch
          | :damage_larger_than_1_inch
  @type windscreen_zone_matrix :: :unavailable | :horizontal_size | :vertical_size
  @type windscreen_damage_zone :: :unknown | :horizontal_position | :vertical_position
  @type windscreen_needs_replacement :: :unknown | :no_replacement_needed | :replacement_needed

  @type t :: %__MODULE__{
          wipers: %PropertyComponent{data: wipers} | nil,
          wipers_intensity: %PropertyComponent{data: wipers_intensity} | nil,
          windscreen_damage: %PropertyComponent{data: windscreen_damage} | nil,
          windscreen_zone_matrix: %PropertyComponent{data: windscreen_zone_matrix} | nil,
          windscreen_damage_zone: %PropertyComponent{data: windscreen_damage_zone} | nil,
          windscreen_needs_replacement:
            %PropertyComponent{data: windscreen_needs_replacement} | nil,
          windscreen_damage_confidence: %PropertyComponent{data: float} | nil,
          windscreen_damage_detection_time: %PropertyComponent{data: integer} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 4, 1, 0, 1, 2>>
    iex> AutoApi.WindscreenState.from_bin(bin)
    %AutoApi.WindscreenState{wipers: %AutoApi.PropertyComponent{data: :automatic}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.WindscreenState{wipers: %AutoApi.PropertyComponent{data: :automatic}}
    iex> AutoApi.WindscreenState.to_bin(state)
    <<1, 0, 4, 1, 0, 1, 2>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end