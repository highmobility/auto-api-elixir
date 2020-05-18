defmodule AutoApi.OffroadState do
  @moduledoc """
  Offroad state
  """

  alias AutoApi.{CommonData, PropertyComponent}

  defstruct route_incline: nil,
            wheel_suspension: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "offroad.json"

  @type t :: %__MODULE__{
          route_incline: %PropertyComponent{data: integer} | nil,
          wheel_suspension: %PropertyComponent{data: float} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 5, 1, 0, 2, 0, 22>>
    iex> AutoApi.OffroadState.from_bin(bin)
    %AutoApi.OffroadState{route_incline: %AutoApi.PropertyComponent{data: 22}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.OffroadState{route_incline: %AutoApi.PropertyComponent{data: 22}}
    iex> AutoApi.OffroadState.to_bin(state)
    <<1, 0, 5, 1, 0, 2, 0, 22>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
