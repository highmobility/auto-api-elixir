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

  alias AutoApi.{CommonData, State, UnitType}

  use AutoApi.State, spec_file: "usage.json"

  @type distance_over_time :: %{
          distance: UnitType.length(),
          time: UnitType.duration()
        }
  @type driving_modes_activation_period :: %{
          driving_mode: CommonData.driving_mode(),
          period: float
        }
  @type driving_mode_energy_consumption :: %{
          driving_mode: CommonData.driving_mode(),
          consumption: UnitType.energy()
        }
  @type grade :: :excellent | :normal | :warning

  @type trip_meter :: %{
          id: byte(),
          distance: UnitType.length()
        }

  @type t :: %__MODULE__{
          average_weekly_distance: State.property(UnitType.length()),
          average_weekly_distance_long_run: State.property(UnitType.length()),
          acceleration_evaluation: State.property(float),
          driving_style_evaluation: State.property(float),
          driving_modes_activation_periods:
            State.multiple_property(driving_modes_activation_period),
          driving_modes_energy_consumptions:
            State.multiple_property(driving_mode_energy_consumption),
          last_trip_energy_consumption: State.property(UnitType.energy()),
          last_trip_fuel_consumption: State.property(UnitType.volume()),
          # Deprecated
          mileage_after_last_trip: State.property(UnitType.length()),
          last_trip_electric_portion: State.property(float),
          last_trip_average_energy_recuperation: State.property(UnitType.energy_efficiency()),
          last_trip_battery_remaining: State.property(float),
          last_trip_date: State.property(DateTime.t()),
          average_fuel_consumption: State.property(UnitType.fuel_efficiency()),
          current_fuel_consumption: State.property(UnitType.fuel_efficiency()),
          odometer_after_last_trip: State.property(UnitType.length()),
          safety_driving_score: State.property(float),
          rapid_acceleration_grade: State.property(grade()),
          rapid_deceleration_grade: State.property(grade()),
          late_night_grade: State.property(grade()),
          distance_over_time: State.property(distance_over_time),
          electric_consumption_rate_since_start: State.property(UnitType.energy_efficiency()),
          electric_consumption_rate_since_reset: State.property(UnitType.energy_efficiency()),
          electric_distance_last_trip: State.property(UnitType.length()),
          electric_distance_since_reset: State.property(UnitType.length()),
          electric_duration_last_trip: State.property(UnitType.duration()),
          electric_duration_since_reset: State.property(UnitType.duration()),
          fuel_consumption_rate_last_trip: State.property(UnitType.fuel_efficiency()),
          fuel_consumption_rate_since_reset: State.property(UnitType.fuel_efficiency()),
          average_speed_last_trip: State.property(UnitType.speed()),
          average_speed_since_reset: State.property(UnitType.speed()),
          fuel_distance_last_trip: State.property(UnitType.length()),
          fuel_distance_since_reset: State.property(UnitType.length()),
          driving_duration_last_trip: State.property(UnitType.duration()),
          driving_duration_since_reset: State.property(UnitType.duration()),
          eco_score_total: State.property(float()),
          eco_score_free_wheel: State.property(float()),
          eco_score_constant: State.property(float()),
          eco_score_bonus_range: State.property(UnitType.length()),
          trip_meters: State.multiple_property(trip_meter())
        }

  @doc """
  Build state based on binary value

    iex> bin = <<17, 0, 11, 1, 0, 8, 63, 229, 112, 163, 215, 10, 61, 113>>
    iex> AutoApi.UsageState.from_bin(bin)
    %AutoApi.UsageState{safety_driving_score: %AutoApi.Property{data: 0.67}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.UsageState{safety_driving_score: %AutoApi.Property{data: 0.67}}
    iex> AutoApi.UsageState.to_bin(state)
    <<17, 0, 11, 1, 0, 8, 63, 229, 112, 163, 215, 10, 61, 113>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
