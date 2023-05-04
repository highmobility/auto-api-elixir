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
defmodule AutoApi.TextInputState do
  @moduledoc """
  TextInput state
  """

  use AutoApi.State, spec_file: "text_input.json"

  @doc """
  Build state based on binary value

    iex> text = "Rendezvous with Rama"
    iex> size = byte_size(text)
    iex> AutoApi.TextInputState.from_bin(<<1, size + 3::integer-16, 1, size::integer-16, text::binary>>)
    %AutoApi.TextInputState{text: %AutoApi.Property{data: "Rendezvous with Rama"}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> text = "Rendezvous with Rama"
    iex> state = %AutoApi.TextInputState{text: %AutoApi.Property{data: text}}
    iex> AutoApi.TextInputState.to_bin(state)
    <<1, 23::integer-16, 1, 20::integer-16, 0x52, 0x65, 0x6E, 0x64, 0x65, 0x7A, 0x76, 0x6F, 0x75, 0x73, 0x20, 0x77, 0x69,  0x74, 0x68, 0x20, 0x52, 0x61, 0x6D, 0x61>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
