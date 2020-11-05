defmodule AutoApiL11.MobileState do
  @moduledoc """
  Browser state
  """

  alias AutoApiL11.PropertyComponent

  defstruct connection: nil,
            timestamp: nil

  use AutoApiL11.State, spec_file: "specs/mobile.json"

  @type connection :: :disconnected | :connected

  @type t :: %__MODULE__{
          connection: %PropertyComponent{data: connection} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> AutoApiL11.MobileState.from_bin(<<1, 4::integer-16, 1, 0, 1, 1>>)
    %AutoApiL11.MobileState{connection: %AutoApiL11.PropertyComponent{data: :connected}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApiL11.MobileState{connection: %AutoApiL11.PropertyComponent{data: :connected}}
    iex> AutoApiL11.MobileState.to_bin(state)
    <<1, 4::integer-16, 1, 0, 1, 1>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
