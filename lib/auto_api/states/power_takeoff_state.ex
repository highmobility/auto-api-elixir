defmodule AutoApiL11.PowerTakeoffState do
  @moduledoc """
  PowerTakeoff state
  """

  alias AutoApiL11.{CommonData, PropertyComponent}

  defstruct status: nil,
            engaged: nil,
            timestamp: nil

  use AutoApiL11.State, spec_file: "specs/power_takeoff.json"

  @type power_takeoff_engaged :: :not_engaged | :engaged

  @type t :: %__MODULE__{
          status: %PropertyComponent{data: CommonData.activity()} | nil,
          engaged: %PropertyComponent{data: power_takeoff_engaged} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 4, 1, 0, 1, 1>>
    iex> AutoApiL11.PowerTakeoffState.from_bin(bin)
    %AutoApiL11.PowerTakeoffState{status: %AutoApiL11.PropertyComponent{data: :active}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApiL11.PowerTakeoffState{status: %AutoApiL11.PropertyComponent{data: :active}}
    iex> AutoApiL11.PowerTakeoffState.to_bin(state)
    <<1, 0, 4, 1, 0, 1, 1>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
