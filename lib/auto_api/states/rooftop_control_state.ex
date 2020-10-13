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

  alias AutoApi.PropertyComponent

  @type convertible_roof_state :: :closed | :open
  @type sunroof_tilt_state :: :closed | :tilt | :half_tilt
  @type sunroof_state :: :closed | :open | :intermediate

  use AutoApi.State, spec_file: "rooftop_control.json"

  @type t :: %__MODULE__{
          dimming: %PropertyComponent{data: float} | nil,
          position: %PropertyComponent{data: float} | nil,
          convertible_roof_state: %PropertyComponent{data: convertible_roof_state} | nil,
          sunroof_tilt_state: %PropertyComponent{data: sunroof_tilt_state} | nil,
          sunroof_state: %PropertyComponent{data: sunroof_state} | nil
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

    iex> state = %AutoApi.RooftopControlState{dimming: %AutoApi.PropertyComponent{data: 0.17}}
    iex> AutoApi.RooftopControlState.to_bin(state)
    <<1, 0, 11, 1, 0, 8, 63, 197, 194, 143, 92, 40, 245, 195>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
