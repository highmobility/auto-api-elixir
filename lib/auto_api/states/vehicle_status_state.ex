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
defmodule AutoApi.VehicleStatusState do
  @moduledoc """
  VehicleStatus state
  """

  alias AutoApi.State

  use AutoApi.State, spec_file: "vehicle_status.json"

  @type t :: %__MODULE__{
          states: State.multiple_property(struct())
        }

  @doc """
  Build state based on binary value

    iex> bin = <<153, 0, 14, 1, 0, 11, 12, 0, 103, 1, 1, 0, 4, 1, 0, 1, 2>>
    iex> state = AutoApi.VehicleStatusState.from_bin(bin)
    iex> [%AutoApi.Property{data: hood_state}] = state.states
    iex> hood_state
    %AutoApi.HoodState{position: %AutoApi.Property{data: :intermediate}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> hood_state = %AutoApi.HoodState{position: %AutoApi.Property{data: :intermediate}}
    iex> state = %AutoApi.VehicleStatusState{states: [%AutoApi.Property{data: hood_state}]}
    iex> AutoApi.VehicleStatusState.to_bin(state)
    <<153, 0, 14, 1, 0, 11, 12, 0, 103, 1, 1, 0, 4, 1, 0, 1, 2>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
