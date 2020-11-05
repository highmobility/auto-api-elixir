defmodule AutoApiL11.OffroadCapability do
  @moduledoc """
  Basic settings for Offroad Capability

      iex> alias AutoApiL11.OffroadCapability, as: O
      iex> O.identifier
      <<0x00, 0x52>>
      iex> O.name
      :offroad
      iex> O.description
      "Offroad"
      iex> length(O.properties)
      2
      iex> List.last(O.properties)
      {0x02, :wheel_suspension}
  """

  @command_module AutoApiL11.OffroadCommand
  @state_module AutoApiL11.OffroadState

  use AutoApiL11.Capability, spec_file: "specs/offroad.json"
end
