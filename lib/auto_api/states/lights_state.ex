# AutoAPI
# The MIT License
#
# Copyright (c) 2018- High-Mobility GmbH (https://high-mobility.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
defmodule AutoApi.LightsState do
  @moduledoc """
  Lights state
  """

  alias AutoApi.{CommonData, State}

  use AutoApi.State, spec_file: "lights.json"

  @type front_exterior_light :: :inactive | :active | :active_with_full_beam | :dlr | :automatic
  @type ambient_light :: %{
          red: integer,
          green: integer,
          blue: integer
        }
  @type light :: %{
          location: CommonData.location_longitudinal(),
          state: CommonData.activity()
        }
  @type reading_lamp :: %{
          location: CommonData.location(),
          state: CommonData.activity()
        }
  @type switch_position ::
          :automatic
          | :dipped_headlights
          | :parking_light_right
          | :parking_light_left
          | :sidelights

  @type t :: %__MODULE__{
          front_exterior_light: State.property(front_exterior_light),
          rear_exterior_light: State.property(CommonData.activity()),
          ambient_light_colour: State.property(ambient_light),
          reverse_light: State.property(CommonData.activity()),
          emergency_brake_light: State.property(CommonData.activity()),
          fog_lights: State.multiple_property(light),
          reading_lamps: State.multiple_property(reading_lamp),
          interior_lights: State.multiple_property(light),
          switch_position: State.property(switch_position())
        }

  @doc """
  Build state based on binary value

    iex> bin = <<5, 0, 4, 1, 0, 1, 1>>
    iex> AutoApi.LightsState.from_bin(bin)
    %AutoApi.LightsState{reverse_light: %AutoApi.PropertyComponent{data: :active}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.LightsState{reverse_light: %AutoApi.PropertyComponent{data: :active}}
    iex> AutoApi.LightsState.to_bin(state)
    <<5, 0, 4, 1, 0, 1, 1>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
