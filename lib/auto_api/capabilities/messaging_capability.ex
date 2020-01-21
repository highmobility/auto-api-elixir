defmodule AutoApi.MessagingCapability do
  @moduledoc """
  Basic settings for Messaging Capability

      iex> alias AutoApi.MessagingCapability, as: M
      iex> M.identifier
      <<0x00, 0x37>>
      iex> M.name
      :messaging
      iex> M.description
      "Messaging"
      iex> length(M.properties)
      2
  """

  @command_module AutoApi.MessagingCommand
  @state_module AutoApi.MessagingState

  use AutoApi.Capability, spec_file: "specs/messaging.json"
end
