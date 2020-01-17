defmodule AutoApi.CruiseControlState do
  @moduledoc """
  CruiseControl state
  """

  alias AutoApi.{CommonData, PropertyComponent}

  defstruct cruise_control: nil,
            limiter: nil,
            target_speed: nil,
            adaptive_cruise_control: nil,
            acc_target_speed: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "specs/cruise_control.json"

  @type limiter :: :not_set | :higher_speed_requested | :lower_speed_requested | :speed_fixed

  @type t :: %__MODULE__{
          cruise_control: %PropertyComponent{data: CommonData.activity()} | nil,
          limiter: %PropertyComponent{data: limiter} | nil,
          target_speed: %PropertyComponent{data: integer} | nil,
          adaptive_cruise_control: %PropertyComponent{data: CommonData.activity()} | nil,
          acc_target_speed: %PropertyComponent{data: integer} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 4, 1, 0, 1, 1>>
    iex> AutoApi.CruiseControlState.from_bin(bin)
    %AutoApi.CruiseControlState{cruise_control: %AutoApi.PropertyComponent{data: :active}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.CruiseControlState{cruise_control: %AutoApi.PropertyComponent{data: :active}}
    iex> AutoApi.CruiseControlState.to_bin(state)
    <<1, 0, 4, 1, 0, 1, 1>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
