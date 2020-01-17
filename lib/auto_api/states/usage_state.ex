defmodule AutoApi.UsageState do
  @moduledoc """
  Usage state
  """

  alias AutoApi.{CommonData, PropertyComponent}

  defstruct average_weekly_distance: nil,
            average_weekly_distance_long_run: nil,
            acceleration_evaluation: nil,
            driving_style_evaluation: nil,
            driving_modes_activation_periods: [],
            driving_modes_energy_consumptions: [],
            last_trip_energy_consumption: nil,
            last_trip_fuel_consumption: nil,
            mileage_after_last_trip: nil,
            last_trip_electric_portion: nil,
            last_trip_average_energy_recuperation: nil,
            last_trip_battery_remaining: nil,
            last_trip_date: nil,
            average_fuel_consumption: nil,
            current_fuel_consumption: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "specs/usage.json"

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
          current_fuel_consumption: %PropertyComponent{data: float} | nil,
          timestamp: DateTime.t() | nil
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
