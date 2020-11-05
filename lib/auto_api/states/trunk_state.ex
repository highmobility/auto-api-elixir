defmodule AutoApiL11.TrunkState do
  @moduledoc """
  Trunk state
  """

  alias AutoApiL11.{CommonData, PropertyComponent}

  defstruct lock: nil,
            position: nil,
            timestamp: nil

  use AutoApiL11.State, spec_file: "specs/trunk.json"

  @type t :: %__MODULE__{
          lock: %PropertyComponent{data: CommonData.lock()} | nil,
          position: %PropertyComponent{data: CommonData.position()} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 4, 1, 0, 1, 1>>
    iex> AutoApiL11.TrunkState.from_bin(bin)
    %AutoApiL11.TrunkState{lock: %AutoApiL11.PropertyComponent{data: :locked}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApiL11.TrunkState{lock: %AutoApiL11.PropertyComponent{data: :locked}}
    iex> AutoApiL11.TrunkState.to_bin(state)
    <<1, 0, 4, 1, 0, 1, 1>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
