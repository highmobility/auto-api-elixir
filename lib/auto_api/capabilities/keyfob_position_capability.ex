defmodule AutoApi.KeyfobPositionCapability do
  @moduledoc """
  Basic settings for KeyfobPosition Capability

      iex> alias AutoApi.KeyfobPositionCapability, as: K
      iex> K.identifier
      <<0x00, 0x48>>
      iex> K.name
      :keyfob_position
      iex> K.description
      "Keyfob Position"
      iex> length(K.properties)
      1
      iex> List.last(K.properties)
      {0x01, :location}
  """

  @command_module AutoApi.KeyfobPositionCommand
  @state_module AutoApi.KeyfobPositionState

  use AutoApi.Capability, spec_file: "keyfob_position.json"
end
