# AutoAPI
# Copyright (C) 2018 High-Mobility GmbH
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see http://www.gnu.org/licenses/.
#
# Please inquire about commercial licensing options at
# licensing@high-mobility.com
defmodule AutoApi.WiFiState do
  @moduledoc """
  WiFi state
  """

  alias AutoApi.PropertyComponent

  defstruct wi_fi_enabled: nil,
            network_connected: nil,
            network_ssid: nil,
            network_security: nil,
            timestamp: nil,
            properties: [],
            property_timestamps: %{}

  use AutoApi.State, spec_file: "specs/wi_fi.json"

  @type wifi_state :: :disabled | :enabled
  @type network_state :: :disconnected | :connected
  @type network_security :: :none | :wep | :wpa | :wpa2_personal

  @type t :: %__MODULE__{
          wi_fi_enabled: %PropertyComponent{data: wifi_state} | nil,
          network_connected: %PropertyComponent{data: network_state} | nil,
          network_ssid: %PropertyComponent{data: String.t()} | nil,
          network_security: %PropertyComponent{data: network_security} | nil,
          timestamp: DateTime.t() | nil,
          properties: list(atom),
          property_timestamps: map()
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 4, 1, 0, 1, 1>>
    iex> AutoApi.WiFiState.from_bin(bin)
    %AutoApi.WiFiState{wi_fi_enabled: %AutoApi.PropertyComponent{data: :enabled}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.WiFiState{wi_fi_enabled: %AutoApi.PropertyComponent{data: :enabled}, properties: [:wifi_enabled]}
    iex> AutoApi.WiFiState.to_bin(state)
    <<1, 0, 4, 1, 0, 1, 1>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
