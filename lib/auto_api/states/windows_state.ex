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
defmodule AutoApiL12.WindowsState do
  @moduledoc """
  Keeps Windows state
  """

  alias AutoApiL12.{CommonData, State}

  use AutoApiL12.State, spec_file: "windows.json"

  @type location :: CommonData.location() | :hatch
  @type position :: :closed | :open | :intermediate
  @type positions :: %{location: location, position: position}
  @type open_percentages :: %{location: location, open_percentage: float}

  @type t :: %__MODULE__{
          open_percentages: State.multiple_property(open_percentages),
          positions: State.multiple_property(positions)
        }

  @doc """
  Build state based on binary value

    iex> bin = <<2, 0, 12, 1, 0, 9, 4, 63, 199, 10, 61, 112, 163, 215, 10>>
    iex> AutoApiL12.WindowsState.from_bin(bin)
    %AutoApiL12.WindowsState{open_percentages: [%AutoApiL12.Property{data: %{location: :hatch, open_percentage: 0.18}}]}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApiL12.WindowsState{open_percentages: [%AutoApiL12.Property{data: %{location: :hatch, open_percentage: 0.18}}]}
    iex> AutoApiL12.WindowsState.to_bin(state)
    <<2, 0, 12, 1, 0, 9, 4, 63, 199, 10, 61, 112, 163, 215, 10>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
