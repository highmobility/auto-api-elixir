defmodule AutoApiL11.WakeUpState do
  @moduledoc """
  WakeUp state
  """

  alias AutoApiL11.{CommonData, PropertyComponent}

  defstruct status: nil,
            timestamp: nil

  use AutoApiL11.State, spec_file: "specs/wake_up.json"

  @type wake_up_state :: :wake_up | :sleep
  @type t :: %__MODULE__{
          status: %PropertyComponent{data: wake_up_state} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 4, 1, 0, 1, 0>>
    iex> AutoApiL11.WakeUpState.from_bin(bin)
    %AutoApiL11.WakeUpState{status: %AutoApiL11.PropertyComponent{data: :wake_up}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApiL11.WakeUpState{status: %AutoApiL11.PropertyComponent{data: :sleep}}
    iex> AutoApiL11.WakeUpState.to_bin(state)
    <<1, 0, 4, 1, 0, 1, 1>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
