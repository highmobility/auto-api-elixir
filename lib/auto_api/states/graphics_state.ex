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
defmodule AutoApi.GraphicsState do
  @moduledoc """
  Graphics state
  """

  use AutoApi.State, spec_file: "graphics.json"

  @doc """
  Build state based on binary value

    iex> url = "https://about.high-mobility.com"
    iex> size = byte_size(url)
    iex> AutoApi.GraphicsState.from_bin(<<1, size + 3::integer-16, 1, size::integer-16, url::binary>>)
    %AutoApi.GraphicsState{image_url: %AutoApi.Property{data: "https://about.high-mobility.com"}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> url = "https://about.high-mobility.com"
    iex> state = %AutoApi.GraphicsState{image_url: %AutoApi.Property{data: url}}
    iex> AutoApi.GraphicsState.to_bin(state)
    <<1, 34::integer-16, 1, 31::integer-16, 0x68, 0x74, 0x74, 0x70, 0x73, 0x3A, 0x2F, 0x2F, 0x61, 0x62, 0x6F, 0x75, 0x74, 0x2E, 0x68, 0x69, 0x67, 0x68, 0x2D, 0x6D, 0x6F, 0x62, 0x69, 0x6C, 0x69, 0x74, 0x79, 0x2E, 0x63, 0x6F, 0x6D>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
