defmodule AutoApi.WeatherConditionsState do
  @moduledoc """
  WeatherConditions state
  """

  alias AutoApi.{CommonData, PropertyComponent}

  defstruct rain_intensity: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "specs/weather_conditions.json"

  @type t :: %__MODULE__{
          rain_intensity: %PropertyComponent{data: float} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 11, 1, 0, 8, 64, 41, 102, 102, 102, 102, 102, 102>>
    iex> AutoApi.WeatherConditionsState.from_bin(bin)
    %AutoApi.WeatherConditionsState{rain_intensity: %AutoApi.PropertyComponent{data: 12.7}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.WeatherConditionsState{rain_intensity: %AutoApi.PropertyComponent{data: 12.7}}
    iex> AutoApi.WeatherConditionsState.to_bin(state)
    <<1, 0, 11, 1, 0, 8, 64, 41, 102, 102, 102, 102, 102, 102>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
