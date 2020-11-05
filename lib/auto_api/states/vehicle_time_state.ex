defmodule AutoApiL11.VehicleTimeState do
  @moduledoc """
  VehicleTime state
  """

  alias AutoApiL11.{CommonData, PropertyComponent}

  defstruct vehicle_time: nil,
            timestamp: nil

  use AutoApiL11.State, spec_file: "specs/vehicle_time.json"

  @type t :: %__MODULE__{
          vehicle_time: %PropertyComponent{data: integer} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 5, 1, 0, 2, 12, 42>>
    iex> AutoApiL11.VehicleTimeState.from_bin(bin)
    %AutoApiL11.VehicleTimeState{vehicle_time: %AutoApiL11.PropertyComponent{data: %{hour: 12, minute: 42}}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApiL11.VehicleTimeState{vehicle_time: %AutoApiL11.PropertyComponent{data: %{hour: 12, minute: 42}}}
    iex> AutoApiL11.VehicleTimeState.to_bin(state)
    <<1, 0, 5, 1, 0, 2, 12, 42>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
