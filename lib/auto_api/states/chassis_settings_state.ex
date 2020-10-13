defmodule AutoApi.ChassisSettingsState do
  @moduledoc """
  ChassisSettings state
  """

  alias AutoApi.{CommonData, State, UnitType}

  defstruct driving_mode: nil,
            sport_chrono: nil,
            current_spring_rates: [],
            maximum_spring_rates: [],
            minimum_spring_rates: [],
            current_chassis_position: nil,
            maximum_chassis_position: nil,
            minimum_chassis_position: nil

  use AutoApi.State, spec_file: "chassis_settings.json"

  @type sport_chrono :: :inactive | :active | :reset
  @type spring_rate :: %{value: UnitType.torque(), axle: CommonData.axle()}

  @type t :: %__MODULE__{
          driving_mode: State.property(CommonData.driving_mode()),
          sport_chrono: State.property(sport_chrono()),
          current_spring_rates: State.multiple_property(spring_rate),
          maximum_spring_rates: State.multiple_property(spring_rate),
          minimum_spring_rates: State.multiple_property(spring_rate),
          current_chassis_position: State.property(UnitType.length()),
          maximum_chassis_position: State.property(UnitType.length()),
          minimum_chassis_position: State.property(UnitType.length())
        }

  @doc """
  Build state based on binary value

    iex> AutoApi.ChassisSettingsState.from_bin(<<1, 4::integer-16, 1, 0, 1, 0>>)
    %AutoApi.ChassisSettingsState{driving_mode: %AutoApi.PropertyComponent{data: :regular}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.ChassisSettingsState{driving_mode: %AutoApi.PropertyComponent{data: :regular}}
    iex> AutoApi.ChassisSettingsState.to_bin(state)
    <<1, 4::integer-16, 1, 0, 1, 0>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
