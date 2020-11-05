defmodule AutoApiL11.KeyfobPositionState do
  @moduledoc """
  KeyfobPosition state
  """

  alias AutoApiL11.PropertyComponent

  defstruct location: nil,
            timestamp: nil

  use AutoApiL11.State, spec_file: "specs/keyfob_position.json"

  @type position ::
          :out_of_range
          | :outside_driver_side
          | :outside_in_front_of_car
          | :outside_passenger_side
          | :outside_behind_car
          | :inside_car

  @type t :: %__MODULE__{
          location: %PropertyComponent{data: position} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> AutoApiL11.KeyfobPositionState.from_bin(<<1, 4::integer-16, 1, 0, 1, 0>>)
    %AutoApiL11.KeyfobPositionState{location: %AutoApiL11.PropertyComponent{data: :out_of_range}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApiL11.KeyfobPositionState{location: %AutoApiL11.PropertyComponent{data: :out_of_range}}
    iex> AutoApiL11.KeyfobPositionState.to_bin(state)
    <<1, 4::integer-16, 1, 0, 1, 0>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
