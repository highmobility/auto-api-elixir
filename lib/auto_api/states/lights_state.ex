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
            ambient_light: nil,
            reverse_light: nil,
            emergency_brake_light: nil,
            fog_lights: [],
            reading_lamps: [],
            interior_lights: [],
            timestamp: nil,
            properties: [],
            property_timestamps: %{}

  use AutoApi.State, spec_file: "specs/lights.json"

  @type front_exterior_light :: :inactive | :active | :active_with_full_beam
  @type activity :: :inactive | :active
  @type light_location :: :front | :rear
  @type ambient_light :: %{rgb_red: integer, rgb_green: integer, rgb_blue: integer}
  @type fog_light :: %{fog_light_location: light_location, fog_light_state: activity}
  @type reading_lamp :: %{
          reading_lamp_location: CommonData.location(),
          reading_lamp_state: activity
        }
  @type interior_lights :: %{
          interior_light_location: light_location,
          interior_light_state: activity
        }

  @type t :: %__MODULE__{
          front_exterior_light: front_exterior_light | nil,
          rear_exterior_light: activity | nil,
          ambient_light: ambient_light | nil,
          reverse_light: activity | nil,
          emergency_brake_light: nil,
          fog_lights: list(fog_light),
          reading_lamps: list(reading_lamp),
          interior_lights: list(reading_lamp),
          timestamp: DateTime.t() | nil,
          properties: list(atom),
          property_timestamps: map()
        }

  @doc """
  Build state based on binary value
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
