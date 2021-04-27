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
defmodule AutoApiL12.LightConditionsState do
  @moduledoc """
  LightConditions state
  """

  alias AutoApiL12.{State, UnitType}

  use AutoApiL12.State, spec_file: "light_conditions.json"

  @type t :: %__MODULE__{
          outside_light: State.property(UnitType.illuminance()),
          inside_light: State.property(UnitType.illuminance())
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 13, 1, 0, 10, 17, 0, 64, 57, 43, 133, 30, 184, 81, 236>>
    iex> AutoApiL12.LightConditionsState.from_bin(bin)
    %AutoApiL12.LightConditionsState{outside_light: %AutoApiL12.Property{data: %{value: 25.17, unit: :lux}}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApiL12.LightConditionsState{outside_light: %AutoApiL12.Property{data: %{value: 25.17, unit: :lux}}}
    iex> AutoApiL12.LightConditionsState.to_bin(state)
    <<1, 0, 13, 1, 0, 10, 17, 0, 64, 57, 43, 133, 30, 184, 81, 236>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
