defmodule AutoApi.LightConditionsCapability do
  @moduledoc """
  Basic settings for Light Conditions Capability

      iex> alias AutoApi.LightConditionsCapability, as: L
      iex> L.identifier
      <<0x00, 0x54>>
      iex> L.name
      :light_conditions
      iex> L.description
      "Light Conditions"
      iex> length(L.properties)
      2
      iex> List.last(L.properties)
      {0x02, :inside_light}
  """

  @command_module AutoApi.LightConditionsCommand
  @state_module AutoApi.LightConditionsState

  use AutoApi.Capability, spec_file: "light_conditions.json"
end
