defmodule AutoApiL11.TextInputState do
  @moduledoc """
  TextInput state
  """

  alias AutoApiL11.PropertyComponent

  defstruct text: nil,
            timestamp: nil

  use AutoApiL11.State, spec_file: "specs/text_input.json"

  @type t :: %__MODULE__{
          text: %PropertyComponent{data: String.t()} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> text = "Rendezvous with Rama"
    iex> size = byte_size(text)
    iex> AutoApiL11.TextInputState.from_bin(<<1, size + 3::integer-16, 1, size::integer-16, text::binary>>)
    %AutoApiL11.TextInputState{text: %AutoApiL11.PropertyComponent{data: "Rendezvous with Rama"}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> text = "Rendezvous with Rama"
    iex> state = %AutoApiL11.TextInputState{text: %AutoApiL11.PropertyComponent{data: text}}
    iex> AutoApiL11.TextInputState.to_bin(state)
    <<1, 23::integer-16, 1, 20::integer-16, 0x52, 0x65, 0x6E, 0x64, 0x65, 0x7A, 0x76, 0x6F, 0x75, 0x73, 0x20, 0x77, 0x69,  0x74, 0x68, 0x20, 0x52, 0x61, 0x6D, 0x61>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
