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
defmodule AutoApi.RooftopControlState do
  @moduledoc """
  Keeps RooftopControl state
  """

  alias AutoApi.State

  @type convertible_roof_state ::
          :closed
          | :open
          | :emergency_locked
          | :closed_secured
          | :open_secured
          | :hard_top_mounted
          | :intermediate_position
          | :loading_position
          | :loading_position_immediate
  @type sunroof_tilt_state :: :closed | :tilted | :half_tilted
  @type sunroof_state :: :closed | :open | :intermediate
  @type sunroof_rain_event ::
          :no_event | :in_stroke_position_because_of_rain | :automatically_in_stroke_position

  use AutoApi.State, spec_file: "rooftop_control.json"

  @type t :: %__MODULE__{
          dimming: State.property(float),
          position: State.property(float),
          convertible_roof_state: State.property(convertible_roof_state),
          sunroof_tilt_state: State.property(sunroof_tilt_state),
          sunroof_state: State.property(sunroof_state),
          sunroof_rain_event: State.property(sunroof_rain_event),
          tilt_position: State.property(float)
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 11, 1, 0, 8, 63, 197, 194, 143, 92, 40, 245, 195>>
    iex> AutoApi.RooftopControlState.from_bin(bin)
    %AutoApi.RooftopControlState{dimming: %AutoApi.Property{data: 0.17}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> state = %AutoApi.RooftopControlState{dimming: %AutoApi.Property{data: 0.17}}
    iex> AutoApi.RooftopControlState.to_bin(state)
    <<1, 0, 11, 1, 0, 8, 63, 197, 194, 143, 92, 40, 245, 195>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
