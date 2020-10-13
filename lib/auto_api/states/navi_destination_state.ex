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
defmodule AutoApi.NaviDestinationState do
  @moduledoc """
  Keeps Navigation Destination state
  """

  alias AutoApi.{CommonData, PropertyComponent}

  use AutoApi.State, spec_file: "navi_destination.json"

  @type t :: %__MODULE__{
          coordinates: %PropertyComponent{data: CommonData.coordinates()} | nil,
          destination_name: %PropertyComponent{data: String.t()} | nil,
          data_slots_free: %PropertyComponent{data: integer} | nil,
          data_slots_max: %PropertyComponent{data: integer} | nil,
          arrival_duration: %PropertyComponent{data: CommonData.time()} | nil,
          distance_to_destination: %PropertyComponent{data: integer} | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<2, 0, 7, 1, 0, 4, 72, 111, 109, 101>>
    iex> AutoApi.NaviDestinationState.from_bin(bin)
    %AutoApi.NaviDestinationState{destination_name: %AutoApi.PropertyComponent{data: "Home"}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.NaviDestinationState{destination_name: %AutoApi.PropertyComponent{data: "Home"}}
    iex> AutoApi.NaviDestinationState.to_bin(state)
    <<2, 0, 7, 1, 0, 4, 72, 111, 109, 101>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
