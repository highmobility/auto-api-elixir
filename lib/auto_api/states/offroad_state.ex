defmodule AutoApiL11.OffroadState do
  @moduledoc """
  Offroad state
  """

  alias AutoApiL11.{CommonData, PropertyComponent}

  defstruct route_incline: nil,
            wheel_suspension: nil,
            timestamp: nil

  use AutoApiL11.State, spec_file: "specs/offroad.json"

  @type t :: %__MODULE__{
          route_incline: %PropertyComponent{data: integer} | nil,
          wheel_suspension: %PropertyComponent{data: float} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 5, 1, 0, 2, 0, 22>>
    iex> AutoApiL11.OffroadState.from_bin(bin)
    %AutoApiL11.OffroadState{route_incline: %AutoApiL11.PropertyComponent{data: 22}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApiL11.OffroadState{route_incline: %AutoApiL11.PropertyComponent{data: 22}}
    iex> AutoApiL11.OffroadState.to_bin(state)
    <<1, 0, 5, 1, 0, 2, 0, 22>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
