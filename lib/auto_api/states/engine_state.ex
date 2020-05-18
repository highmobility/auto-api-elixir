defmodule AutoApi.EngineState do
  @moduledoc """
  Keeps Engine state
  """

  alias AutoApi.PropertyComponent

  @type on_off :: :on | :off

  @type t :: %__MODULE__{
          status: %PropertyComponent{data: on_off} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Engine state
  """
  defstruct status: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "engine.json"

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 4, 1, 0, 1, 0>>
    iex> AutoApi.EngineState.from_bin(bin)
    %AutoApi.EngineState{status: %AutoApi.PropertyComponent{data: :off}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> state = %AutoApi.EngineState{status: %AutoApi.PropertyComponent{data: :on}}
    iex> AutoApi.EngineState.to_bin(state)
    <<1, 0, 4, 1, 0, 1, 1>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
