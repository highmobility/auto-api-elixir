defmodule AutoApiL11.MultiCommandState do
  @moduledoc """
  MultiCommand state
  """

  alias AutoApiL11.{CommonData, PropertyComponent}

  defstruct multi_states: [],
            multi_commands: [],
            timestamp: nil

  use AutoApiL11.State, spec_file: "specs/multi_command.json"

  @type t :: %__MODULE__{
          multi_states: list(%PropertyComponent{}),
          multi_commands: list(%PropertyComponent{}),
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> AutoApiL11.MultiCommandState.from_bin(<<1, 0, 13, 1, 0, 10, 0, 103, 1, 1, 0, 4, 1, 0, 1, 0>>)
    %AutoApiL11.MultiCommandState{multi_states: [%AutoApiL11.PropertyComponent{data: %AutoApiL11.HoodState{position: %AutoApiL11.PropertyComponent{data: :closed}}}]}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApiL11.PropertyComponent{data: %AutoApiL11.HoodState{position: %AutoApiL11.PropertyComponent{data: :closed}}}
    iex> AutoApiL11.MultiCommandState.to_bin(%AutoApiL11.MultiCommandState{multi_states: [state]})
    <<1, 0, 13, 1, 0, 10, 0, 103, 1, 1, 0, 4, 1, 0, 1, 0>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
