defmodule AutoApiL11.BrowserState do
  @moduledoc """
  Browser state
  """

  alias AutoApiL11.PropertyComponent

  defstruct url: nil,
            timestamp: nil

  use AutoApiL11.State, spec_file: "specs/browser.json"

  @type t :: %__MODULE__{
          url: %PropertyComponent{data: String.t()} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> url = "https://about.high-mobility.com"
    iex> size = byte_size(url)
    iex> AutoApiL11.BrowserState.from_bin(<<1, size + 3::integer-16, 1, size::integer-16, url::binary>>)
    %AutoApiL11.BrowserState{url: %AutoApiL11.PropertyComponent{data: "https://about.high-mobility.com"}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> url = "https://about.high-mobility.com"
    iex> state = %AutoApiL11.BrowserState{url: %AutoApiL11.PropertyComponent{data: url}}
    iex> AutoApiL11.BrowserState.to_bin(state)
    <<1, 34::integer-16, 1, 31::integer-16, 0x68, 0x74, 0x74, 0x70, 0x73, 0x3A, 0x2F, 0x2F, 0x61, 0x62, 0x6F, 0x75, 0x74, 0x2E, 0x68, 0x69, 0x67, 0x68, 0x2D, 0x6D, 0x6F, 0x62, 0x69, 0x6C, 0x69, 0x74, 0x79, 0x2E, 0x63, 0x6F, 0x6D>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
