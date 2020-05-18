defmodule AutoApi.LightConditionsState do
  @moduledoc """
  LightConditions state
  """

  alias AutoApi.PropertyComponent

  defstruct outside_light: nil,
            inside_light: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "light_conditions.json"

  @type t :: %__MODULE__{
          outside_light: %PropertyComponent{data: float} | nil,
          inside_light: %PropertyComponent{data: float} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value
    
    iex> bin = <<1, 7::integer-16, 1, 0, 4, 65, 201, 92, 41>>
    iex> AutoApi.LightConditionsState.from_bin(bin)
    %AutoApi.LightConditionsState{outside_light: %AutoApi.PropertyComponent{data: 25.17}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.LightConditionsState{outside_light: %AutoApi.PropertyComponent{data: 25.17}}
    iex> AutoApi.LightConditionsState.to_bin(state)
    <<1, 7::integer-16, 1, 0, 4, 65, 201, 92, 41>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
