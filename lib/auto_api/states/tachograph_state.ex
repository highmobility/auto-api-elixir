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
defmodule AutoApi.TachographState do
  @moduledoc """
  Keeps Tachograph state

  """

  alias AutoApi.PropertyComponent

  use AutoApi.State, spec_file: "tachograph.json"

  @type vehicle_motion :: :not_detected | :detected
  @type vehicle_overspeed :: :no_overspeed | :overspeed
  @type vehicle_direction :: :forward | :reverse
  @type working_state :: :resting | :driver_available | :working | :driving
  @type time_state ::
          :normal
          | :fifteen_min_before_four
          | :four_reached
          | :fifteen_min_before_nine
          | :nine_reached
          | :fifteen_min_before_sixteen
          | :sixteen_reached
  @type card_present :: :not_present | :present
  @type driver_working_state :: %PropertyComponent{
          data: %{working_state: working_state, driver_number: integer}
        }
  @type driver_time_state :: %PropertyComponent{
          data: %{time_state: time_state, driver_number: integer}
        }
  @type drivers_cards_present :: %PropertyComponent{
          data: %{card_present: card_present, driver_number: integer}
        }

  @type t :: %__MODULE__{
          drivers_working_states: list(driver_working_state),
          drivers_time_states: list(driver_time_state),
          drivers_cards_present: list(drivers_cards_present),
          vehicle_motion: %PropertyComponent{data: vehicle_motion} | nil,
          vehicle_overspeed: %PropertyComponent{data: vehicle_overspeed} | nil,
          vehicle_direction: %PropertyComponent{data: vehicle_direction} | nil,
          vehicle_speed: %PropertyComponent{data: integer} | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<4, 0, 4, 1, 0, 1, 1>>
    iex> AutoApi.TachographState.from_bin(bin)
    %AutoApi.TachographState{vehicle_motion: %AutoApi.PropertyComponent{data: :detected}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> state = %AutoApi.TachographState{vehicle_motion: %AutoApi.PropertyComponent{data: :detected}}
    iex> AutoApi.TachographState.to_bin(state)
    <<4, 0, 4, 1, 0, 1, 1>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
