defmodule AutoApi.OffroadCapability do
  @moduledoc """
  Basic settings for Offroad Capability

      iex> alias AutoApi.OffroadCapability, as: O
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

  @command_module AutoApi.OffroadCommand
  @state_module AutoApi.OffroadState

  use AutoApi.Capability, spec_file: "offroad.json"
end
