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

  alias AutoApi.{CommonData, PropertyComponent}

  use AutoApi.State, spec_file: "lights.json"

  @type front_exterior_light :: :inactive | :active | :active_with_full_beam | :dlr | :automatic
  @type light_location :: :front | :rear
  @type ambient_light :: %{red: integer, green: integer, blue: integer}
  @type fog_light :: %PropertyComponent{
          data: %{location: light_location, state: CommonData.activity()}
        }
  @type reading_lamp :: %PropertyComponent{
          data: %{
            location: CommonData.location(),
            state: CommonData.activity()
          }
        }
  @type interior_lights :: %PropertyComponent{
          data: %{
            location: light_location,
            state: CommonData.activity()
          }
        }

  @type t :: %__MODULE__{
          front_exterior_light: %PropertyComponent{data: front_exterior_light} | nil,
          rear_exterior_light: %PropertyComponent{data: CommonData.activity()} | nil,
          ambient_light_colour: %PropertyComponent{data: ambient_light} | nil,
          reverse_light: %PropertyComponent{data: CommonData.activity()} | nil,
          emergency_brake_light: %PropertyComponent{data: CommonData.activity()} | nil,
          fog_lights: list(fog_light),
          reading_lamps: list(reading_lamp),
          interior_lights: list(interior_lights)
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
