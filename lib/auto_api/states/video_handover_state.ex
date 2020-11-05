defmodule AutoApiL11.VideoHandoverState do
  @moduledoc """
  VideoHandover state
  """

  alias AutoApiL11.PropertyComponent

  defstruct url: nil,
            starting_second: nil,
            screen: nil,
            timestamp: nil

  use AutoApiL11.State, spec_file: "specs/video_handover.json"

  @type t :: %__MODULE__{
          url: %PropertyComponent{data: String.t()} | nil,
          starting_second: %PropertyComponent{data: String.t()} | nil,
          screen: %PropertyComponent{data: String.t()} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> url = "https://vimeo.com/365286467"
    iex> size = byte_size(url)
    iex> AutoApiL11.VideoHandoverState.from_bin(<<1, size + 3::integer-16, 1, size::integer-16, url::binary>>)
    %AutoApiL11.VideoHandoverState{url: %AutoApiL11.PropertyComponent{data: "https://vimeo.com/365286467"}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> url = "https://vimeo.com/365286467"
    iex> state = %AutoApiL11.VideoHandoverState{url: %AutoApiL11.PropertyComponent{data: url}}
    iex> AutoApiL11.VideoHandoverState.to_bin(state)
    <<1, 30::integer-16, 1, 27::integer-16, 0x68, 0x74, 0x74, 0x70, 0x73, 0x3A, 0x2F, 0x2F, 0x76, 0x69, 0x6D, 0x65, 0x6F, 0x2E, 0x63, 0x6F, 0x6D, 0x2F, 0x33, 0x36, 0x35, 0x32, 0x38, 0x36, 0x34, 0x36, 0x37>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
