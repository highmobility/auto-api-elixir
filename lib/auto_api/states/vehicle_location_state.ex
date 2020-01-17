defmodule AutoApi.VehicleLocationState do
  @moduledoc """
  VehicleLocationState
  """

  alias AutoApi.{CommonData, PropertyComponent}

  defstruct coordinates: nil,
            heading: nil,
            altitude: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "specs/vehicle_location.json"

  @type t :: %__MODULE__{
          coordinates: %PropertyComponent{data: CommonData.coordinates()} | nil,
          heading: %PropertyComponent{data: float} | nil,
          altitude: %PropertyComponent{data: float} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<5, 0, 11, 1, 0, 8, 64, 101, 249, 235, 133, 30, 184, 82>>
    iex> AutoApi.VehicleLocationState.from_bin(bin)
    %AutoApi.VehicleLocationState{heading: %AutoApi.PropertyComponent{data: 175.81}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.VehicleLocationState{heading: %AutoApi.PropertyComponent{data: 175.81}}
    iex> AutoApi.VehicleLocationState.to_bin(state)
    <<5, 0, 11, 1, 0, 8, 64, 101, 249, 235, 133, 30, 184, 82>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
