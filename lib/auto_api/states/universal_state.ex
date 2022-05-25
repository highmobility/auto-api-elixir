# AutoAPI
# The MIT License
#
# Copyright (c) 2021- High-Mobility GmbH (https://high-mobility.com)
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
defmodule AutoApi.UniversalState do
  @moduledoc """
  Universal state
  """

  use AutoApi.State, spec_file: "universal.json"

  @doc """
  Build state based on binary value

    iex> bin = <<0xA4, 0x0, 0x4, 0x1, 0x0, 0x1, 0x14>>
    iex> AutoApi.UniversalState.from_bin(bin)
    %AutoApi.UniversalState{brand: %AutoApi.Property{data: :jeep}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.UniversalState{vin: %AutoApi.Property{data: "VIN00000000000000"}}
    iex> AutoApi.UniversalState.to_bin(state)
    <<0xA3, 0x0, 0x14, 0x1, 0x0, 0x11, 0x56, 0x49, 0x4E, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30>>

    iex> state = %AutoApi.UniversalState{brand: %AutoApi.Property{data: :jeep}}
    iex> AutoApi.UniversalState.to_bin(state)
    <<0xA4, 0x0, 0x4, 0x1, 0x0, 0x1, 0x14>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
