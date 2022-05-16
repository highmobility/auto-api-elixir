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
defmodule AutoApi.VideoHandoverState do
  @moduledoc """
  VideoHandover state
  """

  use AutoApi.State, spec_file: "video_handover.json"

  @doc """
  Build state based on binary value

    iex> url = "https://vimeo.com/365286467"
    iex> size = byte_size(url)
    iex> AutoApi.VideoHandoverState.from_bin(<<1, size + 3::integer-16, 1, size::integer-16, url::binary>>)
    %AutoApi.VideoHandoverState{url: %AutoApi.Property{data: "https://vimeo.com/365286467"}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> url = "https://vimeo.com/365286467"
    iex> state = %AutoApi.VideoHandoverState{url: %AutoApi.Property{data: url}}
    iex> AutoApi.VideoHandoverState.to_bin(state)
    <<1, 30::integer-16, 1, 27::integer-16, 0x68, 0x74, 0x74, 0x70, 0x73, 0x3A, 0x2F, 0x2F, 0x76, 0x69, 0x6D, 0x65, 0x6F, 0x2E, 0x63, 0x6F, 0x6D, 0x2F, 0x33, 0x36, 0x35, 0x32, 0x38, 0x36, 0x34, 0x36, 0x37>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
