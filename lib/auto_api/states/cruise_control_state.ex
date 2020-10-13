defmodule AutoApi.CruiseControlState do
  @moduledoc """
  CruiseControl state
  """

  alias AutoApi.{CommonData, State, UnitType}

  defstruct cruise_control: nil,
            limiter: nil,
            target_speed: nil,
            adaptive_cruise_control: nil,
            acc_target_speed: nil

  use AutoApi.State, spec_file: "cruise_control.json"

  @type limiter :: :not_set | :higher_speed_requested | :lower_speed_requested | :speed_fixed

  @type t :: %__MODULE__{
          cruise_control: State.property(CommonData.activity()),
          limiter: State.property(limiter),
          target_speed: State.property(UnitType.speed()),
          adaptive_cruise_control: State.property(CommonData.activity()),
          acc_target_speed: State.property(UnitType.speed())
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
