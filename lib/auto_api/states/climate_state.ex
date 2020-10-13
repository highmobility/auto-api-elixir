defmodule AutoApi.ClimateState do
  @moduledoc """
  Climate state
  """

  alias AutoApi.{CommonData, State, UnitType}

  defstruct inside_temperature: nil,
            outside_temperature: nil,
            driver_temperature_setting: nil,
            passenger_temperature_setting: nil,
            hvac_state: nil,
            defogging_state: nil,
            defrosting_state: nil,
            ionising_state: nil,
            defrosting_temperature_setting: nil,
            hvac_weekday_starting_times: [],
            rear_temperature_setting: nil

  use AutoApi.State, spec_file: "climate.json"

  @type weekday ::
          :monday | :tuesday | :wednesday | :thursday | :friday | :saturday | :sunday | :automatic

  @type hvac_weekday_starting_time :: %{
          weekday: CommonData.weekday(),
          time: CommonData.time()
        }

  @type t :: %__MODULE__{
          inside_temperature: State.property(UnitType.temperature()),
          outside_temperature: State.property(UnitType.temperature()),
          driver_temperature_setting: State.property(UnitType.temperature()),
          passenger_temperature_setting: State.property(UnitType.temperature()),
          hvac_state: State.property(CommonData.activity()),
          defogging_state: State.property(CommonData.activity()),
          defrosting_state: State.property(CommonData.activity()),
          ionising_state: State.property(CommonData.activity()),
          defrosting_temperature_setting: State.property(UnitType.temperature()),
          hvac_weekday_starting_times: State.multiple_property(hvac_weekday_starting_time()),
          rear_temperature_setting: State.property(UnitType.temperature())
        }

  @doc """
  Build state based on binary value

    iex> AutoApi.ClimateState.from_bin(<<1, 0, 13, 1, 0, 10, 23, 1, 64, 60, 0, 0, 0, 0, 0, 0>>)
    %AutoApi.ClimateState{inside_temperature: %AutoApi.PropertyComponent{data: {28.0, :celsius}}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.ClimateState{inside_temperature: %AutoApi.PropertyComponent{data: {28.00, :celsius}}}
    iex> AutoApi.ClimateState.to_bin(state)
    <<1, 0, 13, 1, 0, 10, 23, 1, 64, 60, 0, 0, 0, 0, 0, 0>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
