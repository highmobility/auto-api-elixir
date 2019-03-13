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
defmodule AutoApi.LightConditionsState do
  @moduledoc """
  LightConditions state
  """

  alias AutoApi.PropertyComponent

  defstruct outside_light: nil,
            inside_light: nil,
            timestamp: nil,
            properties: [],
            property_timestamps: %{}

  use AutoApi.State, spec_file: "specs/light_conditions.json"

  @type t :: %__MODULE__{
          outside_light: %PropertyComponent{data: float} | nil,
          inside_light: %PropertyComponent{data: float} | nil,
          timestamp: DateTime.t() | nil,
          properties: list(atom),
          property_timestamps: map()
        }

  @doc """
  Build state based on binary value
    
    iex> bin = <<1, 7::integer-16, 1, 0, 4, 65, 201, 92, 41>>
    iex> AutoApi.LightConditionsState.from_bin(bin)
    %AutoApi.LightConditionsState{outside_light: %AutoApi.PropertyComponent{data: 25.17}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.LightConditionsState{outside_light: %AutoApi.PropertyComponent{data: 25.17}, properties: [:outside_light]}
    iex> AutoApi.LightConditionsState.to_bin(state)
    <<1, 7::integer-16, 1, 0, 4, 65, 201, 92, 41>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
