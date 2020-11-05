defmodule AutoApiL11.HeartRateState do
  @moduledoc """
  HeartRate state
  """

  alias AutoApiL11.{CommonData, PropertyComponent}

  defstruct heart_rate: nil,
            timestamp: nil

  use AutoApiL11.State, spec_file: "specs/heart_rate.json"

  @type t :: %__MODULE__{
          heart_rate: %PropertyComponent{data: integer} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> AutoApiL11.HeartRateState.from_bin(<<1, 4::integer-16, 1, 1::integer-16, 80>>)
    %AutoApiL11.HeartRateState{heart_rate: %AutoApiL11.PropertyComponent{data: 80}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApiL11.HeartRateState{heart_rate: %AutoApiL11.PropertyComponent{data: 80}}
    iex> AutoApiL11.HeartRateState.to_bin(state)
    <<1, 4::integer-16, 1, 1::integer-16, 80>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
