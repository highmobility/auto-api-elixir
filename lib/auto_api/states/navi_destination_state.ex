defmodule AutoApiL11.NaviDestinationState do
  @moduledoc """
  Keeps Navigation Destination state
  """

  alias AutoApiL11.{CommonData, PropertyComponent}

  @doc """
  Navigation destination state
  """
  defstruct coordinates: nil,
            destination_name: nil,
            data_slots_free: nil,
            data_slots_max: nil,
            arrival_duration: nil,
            distance_to_destination: nil,
            timestamp: nil

  use AutoApiL11.State, spec_file: "specs/navi_destination.json"

  @type t :: %__MODULE__{
          coordinates: %PropertyComponent{data: CommonData.coordinates()} | nil,
          destination_name: %PropertyComponent{data: String.t()} | nil,
          data_slots_free: %PropertyComponent{data: integer} | nil,
          data_slots_max: %PropertyComponent{data: integer} | nil,
          arrival_duration: %PropertyComponent{data: CommonData.time()} | nil,
          distance_to_destination: %PropertyComponent{data: integer} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<2, 0, 7, 1, 0, 4, 72, 111, 109, 101>>
    iex> AutoApiL11.NaviDestinationState.from_bin(bin)
    %AutoApiL11.NaviDestinationState{destination_name: %AutoApiL11.PropertyComponent{data: "Home"}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApiL11.NaviDestinationState{destination_name: %AutoApiL11.PropertyComponent{data: "Home"}}
    iex> AutoApiL11.NaviDestinationState.to_bin(state)
    <<2, 0, 7, 1, 0, 4, 72, 111, 109, 101>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
