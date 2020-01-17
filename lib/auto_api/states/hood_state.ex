defmodule AutoApi.HoodState do
  @moduledoc """
  Keeps Hood state
  """

  alias AutoApi.PropertyComponent

  @type position :: :closed | :open | :intermediate

  @doc """
  Hood state
  """
  defstruct position: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "specs/hood.json"

  @type t :: %__MODULE__{
          position: %PropertyComponent{data: position} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 4, 1, 0, 1, 1>>
    iex> AutoApi.HoodState.from_bin(bin)
    %AutoApi.HoodState{position: %AutoApi.PropertyComponent{data: :open}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> state = %AutoApi.HoodState{position: %AutoApi.PropertyComponent{data: :open}}
    iex> AutoApi.HoodState.to_bin(state)
    <<1, 0, 4, 1, 0, 1, 1>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
