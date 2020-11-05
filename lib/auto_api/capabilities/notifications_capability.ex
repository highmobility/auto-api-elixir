defmodule AutoApiL11.NotificationsCapability do
  @moduledoc """
  Basic settings for Notifications Capability

      iex> alias AutoApiL11.NotificationsCapability, as: N
      iex> N.identifier
      <<0x00, 0x38>>
      iex> N.name
      :notifications
      iex> N.description
      "Notifications"
      iex> length(N.properties)
      4
  """

  @command_module AutoApiL11.NotificationsCommand
  @state_module AutoApiL11.NotificationsState

  use AutoApiL11.Capability, spec_file: "specs/notifications.json"
end
