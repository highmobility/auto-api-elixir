defmodule AutoApi.WiFiCapability do
  @moduledoc """
  Basic settings for WiFi Capability

      iex> alias AutoApi.WiFiCapability, as: W
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

  @command_module AutoApi.WiFiCommand
  @state_module AutoApi.WiFiState

  use AutoApi.Capability, spec_file: "specs/wi_fi.json"
end
