defmodule AutoApiL11.KeyfobPositionCapability do
  @moduledoc """
  Basic settings for KeyfobPosition Capability

      iex> alias AutoApiL11.KeyfobPositionCapability, as: K
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

  @command_module AutoApiL11.KeyfobPositionCommand
  @state_module AutoApiL11.KeyfobPositionState

  use AutoApiL11.Capability, spec_file: "specs/keyfob_position.json"
end
