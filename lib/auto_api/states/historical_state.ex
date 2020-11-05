defmodule AutoApiL11.HistoricalState do
  @moduledoc """
  Historical state
  """

  alias AutoApiL11.{CommonData, PropertyComponent}

  defstruct states: [],
            capability_id: nil,
            start_date: nil,
            end_date: nil,
            timestamp: nil

  use AutoApiL11.State, spec_file: "specs/historical.json"

  @type t :: %__MODULE__{
          states: list(%PropertyComponent{}),
          capability_id: %PropertyComponent{data: integer} | nil,
          start_date: %PropertyComponent{data: DateTime.t()} | nil,
          end_date: %PropertyComponent{data: DateTime.t()} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> AutoApiL11.HistoricalState.from_bin(<<2, 5::integer-16, 1, 2::integer-16, 0x00, 0x60>>)
    %AutoApiL11.HistoricalState{capability_id: %AutoApiL11.PropertyComponent{data: 0x60}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApiL11.HistoricalState{capability_id: %AutoApiL11.PropertyComponent{data: 0x60}}
    iex> AutoApiL11.HistoricalState.to_bin(state)
    <<2, 5::integer-16, 1, 2::integer-16, 0x00, 0x60>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
