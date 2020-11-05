defmodule AutoApiL11.WiFiCapability do
  @moduledoc """
  Basic settings for WiFi Capability

      iex> alias AutoApiL11.WiFiCapability, as: W
      iex> W.identifier
      <<0x00, 0x59>>
      iex> W.name
      :wi_fi
      iex> W.description
      "Wi-Fi"
      iex> length(W.properties)
      5
      iex> W.properties
      [{1, :status}, {2, :network_connected}, {3, :network_ssid}, {4, :network_security}, {5, :password}]
  """

  @command_module AutoApiL11.WiFiCommand
  @state_module AutoApiL11.WiFiState

  use AutoApiL11.Capability, spec_file: "specs/wi_fi.json"
end
