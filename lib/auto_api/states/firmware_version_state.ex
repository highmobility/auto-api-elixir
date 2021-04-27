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
defmodule AutoApiL12.FirmwareVersionState do
  @moduledoc """
  Keeps Firmware Version state

  """

  alias AutoApiL12.State

  use AutoApiL12.State, spec_file: "firmware_version.json"

  @type hmkit_version :: %{
          major: integer,
          minor: integer,
          patch: integer
        }

  @type t :: %__MODULE__{
          hmkit_version: State.property(hmkit_version()),
          hmkit_build_name: State.property(String.t()),
          application_version: State.property(String.t())
        }

  @doc """
  Build state based on binary value

    iex> bin = <<3, 0, 8, 1, 0, 5, 51, 46, 49, 46, 55>>
    iex> AutoApiL12.FirmwareVersionState.from_bin(bin)
    %AutoApiL12.FirmwareVersionState{application_version: %AutoApiL12.Property{data: "3.1.7"}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> state = %AutoApiL12.FirmwareVersionState{application_version: %AutoApiL12.Property{data: "3.1.7"}}
    iex> AutoApiL12.FirmwareVersionState.to_bin(state)
    <<3, 0, 8, 1, 0, 5, 51, 46, 49, 46, 55>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
