defmodule AutoApi.MultiCommandState do
  @moduledoc """
  MultiCommand state
  """

  alias AutoApi.{CommonData, PropertyComponent}

  defstruct multi_states: [],
            multi_commands: [],
            timestamp: nil

  use AutoApi.State, spec_file: "multi_command.json"

  @type t :: %__MODULE__{
          multi_states: list(%PropertyComponent{}),
          multi_commands: list(%PropertyComponent{}),
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> AutoApi.MultiCommandState.from_bin(<<1, 0, 13, 1, 0, 10, 0, 103, 1, 1, 0, 4, 1, 0, 1, 0>>)
    %AutoApi.MultiCommandState{multi_states: [%AutoApi.PropertyComponent{data: %AutoApi.HoodState{position: %AutoApi.PropertyComponent{data: :closed}}}]}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.PropertyComponent{data: %AutoApi.HoodState{position: %AutoApi.PropertyComponent{data: :closed}}}
    iex> AutoApi.MultiCommandState.to_bin(%AutoApi.MultiCommandState{multi_states: [state]})
    <<1, 0, 13, 1, 0, 10, 0, 103, 1, 1, 0, 4, 1, 0, 1, 0>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
