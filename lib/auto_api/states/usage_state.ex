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
defmodule AutoApi.UsageState do
  @moduledoc """
  Usage state
  """

  alias AutoApi.{CommonData, PropertyComponent}

  use AutoApi.State, spec_file: "usage.json"

  @type driving_modes_activation_period :: %PropertyComponent{
          data: %{driving_mode: CommonData.driving_mode(), period: float}
        }
  @type driving_mode_energy_consumption :: %PropertyComponent{
          data: %{driving_mode: CommonData.driving_mode(), consumption: float}
        }

  @type t :: %__MODULE__{
          average_weekly_distance: %PropertyComponent{data: integer} | nil,
          average_weekly_distance_long_run: %PropertyComponent{data: integer} | nil,
          acceleration_evaluation: %PropertyComponent{data: float} | nil,
          driving_style_evaluation: %PropertyComponent{data: float} | nil,
          driving_modes_activation_periods: list(driving_modes_activation_period),
          driving_modes_energy_consumptions: list(driving_mode_energy_consumption),
          last_trip_energy_consumption: %PropertyComponent{data: float} | nil,
          last_trip_fuel_consumption: %PropertyComponent{data: float} | nil,
          mileage_after_last_trip: %PropertyComponent{data: integer} | nil,
          last_trip_electric_portion: %PropertyComponent{data: float} | nil,
          last_trip_average_energy_recuperation: %PropertyComponent{data: float} | nil,
          last_trip_battery_remaining: %PropertyComponent{data: float} | nil,
          last_trip_date: %PropertyComponent{data: integer} | nil,
          average_fuel_consumption: %PropertyComponent{data: float} | nil,
          current_fuel_consumption: %PropertyComponent{data: float} | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 5, 1, 0, 2, 0, 203>>
    iex> AutoApi.UsageState.from_bin(bin)
    %AutoApi.UsageState{average_weekly_distance: %AutoApi.PropertyComponent{data: 203}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.UsageState{average_weekly_distance: %AutoApi.PropertyComponent{data: 203}}
    iex> AutoApi.UsageState.to_bin(state)
    <<1, 0, 5, 1, 0, 2, 0, 203>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
