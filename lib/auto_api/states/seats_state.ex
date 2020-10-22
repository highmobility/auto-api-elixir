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
defmodule AutoApi.SeatsState do
  @moduledoc """
  Seats state
  """

  alias AutoApi.State

  use AutoApi.State, spec_file: "seats.json"

  @type seat_location :: :front_left | :front_right | :rear_right | :rear_left | :rear_center
  @type detected :: :detected | :not_detected
  @type persons_detected :: %{location: seat_location, detected: detected}
  @type seatbelt_state :: :not_fastened | :fastened
  @type seatbelts_state :: %{location: seat_location, fastened_state: seatbelt_state}

  @type t :: %__MODULE__{
          persons_detected: State.multiple_property(persons_detected),
          seatbelts_state: State.multiple_property(seatbelts_state)
        }

  @doc """
  Build state based on binary value

    iex> bin = <<2, 0, 5, 1, 0, 2, 4, 1>>
    iex> AutoApi.SeatsState.from_bin(bin)
    %AutoApi.SeatsState{persons_detected: [%AutoApi.PropertyComponent{data: %{location: :rear_center, detected: :detected}}]}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.SeatsState{persons_detected: [%AutoApi.PropertyComponent{data: %{location: :rear_center, detected: :detected}}]}
    iex> AutoApi.SeatsState.to_bin(state)
    <<2, 0, 5, 1, 0, 2, 4, 1>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
