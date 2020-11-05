defmodule AutoApiL11.WeatherConditionsCapability do
  @moduledoc """
  Basic settings for WeatherConditions Capability

      iex> alias AutoApiL11.WeatherConditionsCapability, as: W
      iex> W.identifier
      <<0x00, 0x55>>
      iex> W.name
      :weather_conditions
      iex> W.description
      "Weather Conditions"
      iex> length(W.properties)
      1
      iex> W.properties
      [{1, :rain_intensity}]
  """

  @command_module AutoApiL11.WeatherConditionsCommand
  @state_module AutoApiL11.WeatherConditionsState

  use AutoApiL11.Capability, spec_file: "specs/weather_conditions.json"
end
