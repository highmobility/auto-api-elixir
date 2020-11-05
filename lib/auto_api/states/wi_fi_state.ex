defmodule AutoApiL11.WiFiState do
  @moduledoc """
  WiFi state
  """

  alias AutoApiL11.{CommonData, PropertyComponent}

  defstruct status: nil,
            network_connected: nil,
            network_ssid: nil,
            network_security: nil,
            password: nil,
            timestamp: nil

  use AutoApiL11.State, spec_file: "specs/wi_fi.json"

  @type t :: %__MODULE__{
          status: %PropertyComponent{data: CommonData.enabled_state()} | nil,
          network_connected: %PropertyComponent{data: CommonData.connection_state()} | nil,
          network_ssid: %PropertyComponent{data: String.t()} | nil,
          network_security: %PropertyComponent{data: CommonData.network_security()} | nil,
          password: %PropertyComponent{data: String.t()} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 4, 1, 0, 1, 1>>
    iex> AutoApiL11.WiFiState.from_bin(bin)
    %AutoApiL11.WiFiState{status: %AutoApiL11.PropertyComponent{data: :enabled}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApiL11.WiFiState{status: %AutoApiL11.PropertyComponent{data: :enabled}}
    iex> AutoApiL11.WiFiState.to_bin(state)
    <<1, 0, 4, 1, 0, 1, 1>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
