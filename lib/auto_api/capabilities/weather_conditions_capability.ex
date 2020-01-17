defmodule AutoApi.WeatherConditionsCapability do
  @moduledoc """
  Basic settings for WeatherConditions Capability

      iex> alias AutoApi.WeatherConditionsCapability, as: W
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

  @command_module AutoApi.WeatherConditionsCommand
  @state_module AutoApi.WeatherConditionsState

  use AutoApi.Capability, spec_file: "specs/weather_conditions.json"
end
