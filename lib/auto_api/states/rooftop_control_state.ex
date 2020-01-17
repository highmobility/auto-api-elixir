defmodule AutoApi.RooftopControlState do
  @moduledoc """
  Keeps RooftopControl state
  """

  alias AutoApi.PropertyComponent

  @type convertible_roof_state :: :closed | :open
  @type sunroof_tilt_state :: :closed | :tilt | :half_tilt
  @type sunroof_state :: :closed | :open | :intermediate

  @doc """
  RooftopControl state
  """
  defstruct dimming: nil,
            position: nil,
            convertible_roof_state: nil,
            sunroof_tilt_state: nil,
            sunroof_state: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "specs/rooftop_control.json"

  @type t :: %__MODULE__{
          dimming: %PropertyComponent{data: float} | nil,
          position: %PropertyComponent{data: float} | nil,
          convertible_roof_state: %PropertyComponent{data: convertible_roof_state} | nil,
          sunroof_tilt_state: %PropertyComponent{data: sunroof_tilt_state} | nil,
          sunroof_state: %PropertyComponent{data: sunroof_state} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 11, 1, 0, 8, 63, 197, 194, 143, 92, 40, 245, 195>>
    iex> AutoApi.RooftopControlState.from_bin(bin)
    %AutoApi.RooftopControlState{dimming: %AutoApi.PropertyComponent{data: 0.17}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> state = %AutoApi.RooftopControlState{dimming: %AutoApi.PropertyComponent{data: 0.17}}
    iex> AutoApi.RooftopControlState.to_bin(state)
    <<1, 0, 11, 1, 0, 8, 63, 197, 194, 143, 92, 40, 245, 195>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
