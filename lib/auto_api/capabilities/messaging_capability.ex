defmodule AutoApiL11.MessagingCapability do
  @moduledoc """
  Basic settings for Messaging Capability

      iex> alias AutoApiL11.MessagingCapability, as: M
      iex> M.identifier
      <<0x00, 0x37>>
      iex> M.name
      :messaging
      iex> M.description
      "Messaging"
      iex> length(M.properties)
      2
  """

  @command_module AutoApiL11.MessagingCommand
  @state_module AutoApiL11.MessagingState

  use AutoApiL11.Capability, spec_file: "specs/messaging.json"
end
