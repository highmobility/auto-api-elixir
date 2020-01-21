defmodule AutoApi.ClimateCapability do
  @moduledoc """
  Basic settings for Climate Capability

      iex> alias AutoApi.ClimateCapability, as: C
      iex> C.identifier
      <<0x00, 0x24>>
      iex> C.name
      :climate
      iex> C.description
      "Climate"
      iex> length(C.properties)
      11
      iex> List.last(C.properties)
      {0x0C, :rear_temperature_setting}
  """

  @command_module AutoApi.ClimateCommand
  @state_module AutoApi.ClimateState

  use AutoApi.Capability, spec_file: "specs/climate.json"
end
