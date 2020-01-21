defmodule AutoApi.MobileState do
  @moduledoc """
  Browser state
  """

  alias AutoApi.PropertyComponent

  defstruct connection: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "specs/mobile.json"

  @type connection :: :disconnected | :connected

  @type t :: %__MODULE__{
          connection: %PropertyComponent{data: connection} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> AutoApi.MobileState.from_bin(<<1, 4::integer-16, 1, 0, 1, 1>>)
    %AutoApi.MobileState{connection: %AutoApi.PropertyComponent{data: :connected}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.MobileState{connection: %AutoApi.PropertyComponent{data: :connected}}
    iex> AutoApi.MobileState.to_bin(state)
    <<1, 4::integer-16, 1, 0, 1, 1>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
