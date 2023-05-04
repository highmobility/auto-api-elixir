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
defmodule AutoApi.MessagingState do
  @moduledoc """
  Messaging state
  """

  use AutoApi.State, spec_file: "messaging.json"

  @doc """
  Build state based on binary value

    iex> text = "Hey mom!"
    iex> size = byte_size(text)
    iex> AutoApi.MessagingState.from_bin(<<1, size + 3::integer-16, 1, size::integer-16, text::binary>>)
    %AutoApi.MessagingState{text: %AutoApi.Property{data: "Hey mom!"}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> text = "Hey mom!"
    iex> state = %AutoApi.MessagingState{text: %AutoApi.Property{data: text}}
    iex> AutoApi.MessagingState.to_bin(state)
    <<1, 11::integer-16, 1, 8::integer-16, 0x48, 0x65, 0x79, 0x20, 0x6D, 0x6F, 0x6D, 0x21>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
