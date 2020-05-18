defmodule AutoApi.ValetModeState do
  @moduledoc """
  ValetMode state
  """

  alias AutoApi.{CommonData, PropertyComponent}

  defstruct status: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "valet_mode.json"

  @type t :: %__MODULE__{
          status: %PropertyComponent{data: CommonData.activity()} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 4, 1, 0, 1, 1>>
    iex> AutoApi.ValetModeState.from_bin(bin)
    %AutoApi.ValetModeState{status: %AutoApi.PropertyComponent{data: :active}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.ValetModeState{status: %AutoApi.PropertyComponent{data: :active}}
    iex> AutoApi.ValetModeState.to_bin(state)
    <<1, 0, 4, 1, 0, 1, 1>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
