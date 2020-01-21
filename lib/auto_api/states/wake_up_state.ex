defmodule AutoApi.WakeUpState do
  @moduledoc """
  WakeUp state
  """

  alias AutoApi.{CommonData, PropertyComponent}

  defstruct status: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "specs/wake_up.json"

  @type wake_up_state :: :wake_up | :sleep
  @type t :: %__MODULE__{
          status: %PropertyComponent{data: wake_up_state} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 4, 1, 0, 1, 0>>
    iex> AutoApi.WakeUpState.from_bin(bin)
    %AutoApi.WakeUpState{status: %AutoApi.PropertyComponent{data: :wake_up}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.WakeUpState{status: %AutoApi.PropertyComponent{data: :sleep}}
    iex> AutoApi.WakeUpState.to_bin(state)
    <<1, 0, 4, 1, 0, 1, 1>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
