defmodule AutoApiL11.ParkingBrakeState do
  @moduledoc """
  ParkingBrake state
  """

  alias AutoApiL11.{CommonData, PropertyComponent}

  defstruct status: nil,
            timestamp: nil

  use AutoApiL11.State, spec_file: "specs/parking_brake.json"

  @type t :: %__MODULE__{
          status: %PropertyComponent{data: CommonData.activity()} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 4, 1, 0, 1, 1>>
    iex> AutoApiL11.ParkingBrakeState.from_bin(bin)
    %AutoApiL11.ParkingBrakeState{status: %AutoApiL11.PropertyComponent{data: :active}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApiL11.ParkingBrakeState{status: %AutoApiL11.PropertyComponent{data: :active}}
    iex> AutoApiL11.ParkingBrakeState.to_bin(state)
    <<1, 0, 4, 1, 0, 1, 1>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
