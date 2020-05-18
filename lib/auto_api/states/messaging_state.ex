defmodule AutoApi.MessagingState do
  @moduledoc """
  Messaging state
  """

  alias AutoApi.PropertyComponent

  defstruct text: nil,
            handle: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "messaging.json"

  @type t :: %__MODULE__{
          text: %PropertyComponent{data: String.t()} | nil,
          handle: %PropertyComponent{data: String.t()} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> text = "Hey mom!"
    iex> size = byte_size(text)
    iex> AutoApi.MessagingState.from_bin(<<1, size + 3::integer-16, 1, size::integer-16, text::binary>>)
    %AutoApi.MessagingState{text: %AutoApi.PropertyComponent{data: "Hey mom!"}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> text = "Hey mom!"
    iex> state = %AutoApi.MessagingState{text: %AutoApi.PropertyComponent{data: text}}
    iex> AutoApi.MessagingState.to_bin(state)
    <<1, 11::integer-16, 1, 8::integer-16, 0x48, 0x65, 0x79, 0x20, 0x6D, 0x6F, 0x6D, 0x21>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
