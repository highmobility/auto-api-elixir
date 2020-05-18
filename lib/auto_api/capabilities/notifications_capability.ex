defmodule AutoApi.NotificationsCapability do
  @moduledoc """
  Basic settings for Notifications Capability

      iex> alias AutoApi.NotificationsCapability, as: N
      iex> N.identifier
      <<0x00, 0x38>>
      iex> N.name
      :notifications
      iex> N.description
      "Notifications"
      iex> length(N.properties)
      4
  """

  @command_module AutoApi.NotificationsCommand
  @state_module AutoApi.NotificationsState

  use AutoApi.Capability, spec_file: "notifications.json"
end
