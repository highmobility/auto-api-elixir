defmodule AutoApiL11.LightConditionsCapability do
  @moduledoc """
  Basic settings for Light Conditions Capability

      iex> alias AutoApiL11.LightConditionsCapability, as: L
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

  @command_module AutoApiL11.LightConditionsCommand
  @state_module AutoApiL11.LightConditionsState

  use AutoApiL11.Capability, spec_file: "specs/light_conditions.json"
end
