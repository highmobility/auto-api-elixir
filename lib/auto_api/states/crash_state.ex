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
defmodule AutoApi.CrashState do
  @moduledoc """
  Keeps Crash state
  """

  alias AutoApi.{CommonData, State}

  use AutoApi.State, spec_file: "crash.json"

  @type crash_incident :: %{
          location: :front | :lateral | :rear,
          severity: :very_high | :high | :medium | :low,
          repairs: :unknown | :needed | :not_needed
        }

  @type type :: :pedestrian | :non_pedestrian

  @type tipped_state :: :tipped_over | :not_tipped

  @type impact_zone ::
          :predestrian_protection
          | :rollover
          | :rear_passenger_side
          | :rear_driver_side
          | :side_passeger_side
          | :side_driver_side
          | :front_passenger_side
          | :front_driver_side

  @type t :: %__MODULE__{
          incidents: State.multiple_property(crash_incident()),
          type: State.property(type()),
          tipped_state: State.property(tipped_state()),
          automatic_ecall: State.property(CommonData.enabled_state()),
          severity: State.property(integer()),
          impact_zone: State.multiple_property(impact_zone())
        }

  @doc """
  Build state based on binary value

    iex> bin = <<5, 0, 4, 1, 0, 1, 3>>
    iex> AutoApi.CrashState.from_bin(bin)
    %AutoApi.CrashState{severity: %AutoApi.Property{data: 3}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> state = %AutoApi.CrashState{tipped_state: %AutoApi.Property{data: :not_tipped}}
    iex> AutoApi.CrashState.to_bin(state)
    <<3, 0, 4, 1, 0, 1, 1>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
