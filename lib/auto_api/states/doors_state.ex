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
defmodule AutoApiL12.DoorsState do
  @moduledoc """
  Door position possible values: :closed, :open
  Door lock possible values: :unlocked, :locked
  """

  alias AutoApiL12.{CommonData, State}

  use AutoApiL12.State, spec_file: "doors.json"

  @type lock :: %{
          location: CommonData.location(),
          lock_state: CommonData.lock()
        }

  @type position :: %{
          location: CommonData.location() | :all,
          position: CommonData.position()
        }

  @type t :: %__MODULE__{
          inside_locks: State.multiple_property(lock),
          locks: State.multiple_property(lock),
          positions: State.multiple_property(position),
          inside_locks_state: State.property(CommonData.lock()),
          locks_state: State.property(CommonData.lock())
        }

  @doc """
  Build state based on binary value

    iex> AutoApiL12.DoorsState.from_bin(<<0x03, 5::integer-16, 0x01, 2::integer-16, 0x00, 0x01>>)
    %AutoApiL12.DoorsState{locks: [%AutoApiL12.Property{data: %{location: :front_left, lock_state: :locked}}]}

    iex> AutoApiL12.DoorsState.from_bin(<<0x04, 5::integer-16,  0x01, 2::integer-16, 0x05, 0x00>>)
    %AutoApiL12.DoorsState{positions: [%AutoApiL12.Property{data: %{location: :all, position: :closed}}]}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin
    iex> AutoApiL12.DoorsState.to_bin(%AutoApiL12.DoorsState{positions: [%AutoApiL12.Property{data: %{location: :front_left, position: :open}}]})
    <<0x04, 5::integer-16, 0x01, 2::integer-16, 0x00, 0x01>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
