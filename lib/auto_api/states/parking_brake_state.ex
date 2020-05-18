defmodule AutoApi.ParkingBrakeState do
  @moduledoc """
  ParkingBrake state
  """

  alias AutoApi.{CommonData, PropertyComponent}

  defstruct status: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "parking_brake.json"

  @type t :: %__MODULE__{
          status: %PropertyComponent{data: CommonData.activity()} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 4, 1, 0, 1, 1>>
    iex> AutoApi.ParkingBrakeState.from_bin(bin)
    %AutoApi.ParkingBrakeState{status: %AutoApi.PropertyComponent{data: :active}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.ParkingBrakeState{status: %AutoApi.PropertyComponent{data: :active}}
    iex> AutoApi.ParkingBrakeState.to_bin(state)
    <<1, 0, 4, 1, 0, 1, 1>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
