defmodule AutoApi.FailureMessageCapability do
  @moduledoc """
  Basic settings for FailureMessage Capability

      iex> alias AutoApi.FailureMessageCapability, as: F
      iex> F.identifier
      <<0x00, 0x2>>
      iex> F.name
      :failure_message
      iex> F.description
      "Failure Message"
      iex> length(F.properties)
      5
      iex> List.last(F.properties)
      {5, :failed_property_ids}
  """

  @command_module AutoApi.FailureMessageCommand
  @state_module AutoApi.FailureMessageState

  use AutoApi.Capability, spec_file: "specs/failure_message.json"
end
