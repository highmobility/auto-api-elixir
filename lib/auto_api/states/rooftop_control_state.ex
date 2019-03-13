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
defmodule AutoApi.RooftopControlState do
  @moduledoc """
  Keeps RooftopControl state
  """

  alias AutoApi.PropertyComponent

  @type convertible_roof_state :: :closed | :open
  @type sunroof_tilt_state :: :closed | :tilt | :half_tilt
  @type sunroof_state :: :closed | :open | :intermediate

  @doc """
  RooftopControl state
  """
  defstruct dimming: nil,
            position: nil,
            convertible_roof_state: nil,
            sunroof_tilt_state: nil,
            sunroof_state: nil,
            timestamp: nil,
            properties: [],
            property_timestamps: %{}

  use AutoApi.State, spec_file: "specs/rooftop_control.json"

  @type t :: %__MODULE__{
          dimming: %PropertyComponent{data: float} | nil,
          position: %PropertyComponent{data: float} | nil,
          convertible_roof_state: %PropertyComponent{data: convertible_roof_state} | nil,
          sunroof_tilt_state: %PropertyComponent{data: sunroof_tilt_state} | nil,
          sunroof_state: %PropertyComponent{data: sunroof_state} | nil,
          timestamp: DateTime.t() | nil,
          properties: list(atom),
          property_timestamps: map()
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 11, 1, 0, 8, 63, 197, 194, 143, 92, 40, 245, 195>>
    iex> AutoApi.RooftopControlState.from_bin(bin)
    %AutoApi.RooftopControlState{dimming: %AutoApi.PropertyComponent{data: 0.17}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> state = %AutoApi.RooftopControlState{dimming: %AutoApi.PropertyComponent{data: 0.17}, properties: [:dimming]}
    iex> AutoApi.RooftopControlState.to_bin(state)
    <<1, 0, 11, 1, 0, 8, 63, 197, 194, 143, 92, 40, 245, 195>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
