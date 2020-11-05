defmodule AutoApiL11.ChassisSettingsState do
  @moduledoc """
  ChassisSettings state
  """

  alias AutoApiL11.{CommonData, PropertyComponent}

  defstruct driving_mode: nil,
            sport_chrono: nil,
            current_spring_rates: [],
            maximum_spring_rates: [],
            minimum_spring_rates: [],
            current_chassis_position: nil,
            maximum_chassis_position: nil,
            minimum_chassis_position: nil,
            timestamp: nil

  use AutoApiL11.State, spec_file: "specs/chassis_settings.json"

  @type spring_rate :: %PropertyComponent{data: %{value: integer, axle: CommonData.axle()}}

  @type t :: %__MODULE__{
          driving_mode: %PropertyComponent{data: CommonData.driving_mode()} | nil,
          sport_chrono: %PropertyComponent{data: CommonData.activity()} | nil,
          current_spring_rates: list(spring_rate),
          maximum_spring_rates: list(spring_rate),
          minimum_spring_rates: list(spring_rate),
          current_chassis_position: %PropertyComponent{data: integer} | nil,
          maximum_chassis_position: %PropertyComponent{data: integer} | nil,
          minimum_chassis_position: %PropertyComponent{data: integer} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> AutoApiL11.ChassisSettingsState.from_bin(<<1, 4::integer-16, 1, 0, 1, 0>>)
    %AutoApiL11.ChassisSettingsState{driving_mode: %AutoApiL11.PropertyComponent{data: :regular}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApiL11.ChassisSettingsState{driving_mode: %AutoApiL11.PropertyComponent{data: :regular}}
    iex> AutoApiL11.ChassisSettingsState.to_bin(state)
    <<1, 4::integer-16, 1, 0, 1, 0>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
