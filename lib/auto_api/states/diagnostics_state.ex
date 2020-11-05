defmodule AutoApiL11.DiagnosticsState do
  @moduledoc """
  Keeps Diagnostics state

  engine_oil_temperature: Engine oil temperature in Celsius, whereas can be negative
  """

  alias AutoApiL11.{CommonData, PropertyComponent}

  @doc """
  Diagnostics state
  """
  defstruct mileage: nil,
            engine_oil_temperature: nil,
            speed: nil,
            engine_rpm: nil,
            fuel_level: nil,
            estimated_range: nil,
            washer_fluid_level: nil,
            battery_voltage: nil,
            adblue_level: nil,
            distance_since_reset: nil,
            distance_since_start: nil,
            fuel_volume: nil,
            anti_lock_braking: nil,
            engine_coolant_temperature: nil,
            engine_total_operating_hours: nil,
            engine_total_fuel_consumption: nil,
            brake_fluid_level: nil,
            engine_torque: nil,
            engine_load: nil,
            wheel_based_speed: nil,
            battery_level: nil,
            check_control_messages: [],
            tire_temperatures: [],
            tire_pressures: [],
            wheel_rpms: [],
            trouble_codes: [],
            mileage_meters: nil,
            timestamp: nil

  use AutoApiL11.State, spec_file: "specs/diagnostics.json"

  @type fluid_level :: :low | :filled
  @type position :: :front_left | :front_right | :rear_right | :rear_left
  @type tire_data :: %{position: position, pressure: float}
  @type check_control_message :: %PropertyComponent{
          data: %{
            id: integer,
            remaining_minutes: integer,
            text: String.t(),
            status: String.t()
          }
        }

  @type tire_temperature :: %PropertyComponent{
          data: %{
            location: CommonData.location(),
            temperature: float
          }
        }

  @type tire_pressure :: %PropertyComponent{
          data: %{
            location: CommonData.location(),
            pressure: float
          }
        }

  @type wheel_rpm :: %PropertyComponent{
          data: %{
            location: CommonData.location(),
            rpm: integer
          }
        }

  @type trouble_code :: %PropertyComponent{
          data: %{
            occurences: integer,
            id: String.t(),
            ecu_id: String.t(),
            status: String.t()
          }
        }

  @type t :: %__MODULE__{
          mileage: %PropertyComponent{data: integer} | nil,
          engine_oil_temperature: %PropertyComponent{data: integer} | nil,
          speed: %PropertyComponent{data: integer} | nil,
          engine_rpm: %PropertyComponent{data: integer} | nil,
          fuel_level: %PropertyComponent{data: float} | nil,
          estimated_range: %PropertyComponent{data: integer} | nil,
          washer_fluid_level: %PropertyComponent{data: fluid_level} | nil,
          battery_voltage: %PropertyComponent{data: float} | nil,
          adblue_level: %PropertyComponent{data: float} | nil,
          distance_since_reset: %PropertyComponent{data: integer} | nil,
          distance_since_start: %PropertyComponent{data: integer} | nil,
          fuel_volume: %PropertyComponent{data: float} | nil,
          anti_lock_braking: %PropertyComponent{data: CommonData.activity()} | nil,
          engine_coolant_temperature: %PropertyComponent{data: integer} | nil,
          engine_total_operating_hours: %PropertyComponent{data: float} | nil,
          engine_total_fuel_consumption: %PropertyComponent{data: float} | nil,
          brake_fluid_level: %PropertyComponent{data: fluid_level} | nil,
          engine_torque: %PropertyComponent{data: float} | nil,
          engine_load: %PropertyComponent{data: float} | nil,
          wheel_based_speed: %PropertyComponent{data: integer} | nil,
          battery_level: %PropertyComponent{data: float} | nil,
          check_control_messages: list(check_control_message),
          tire_pressures: list(tire_pressure),
          tire_temperatures: list(tire_temperature),
          wheel_rpms: list(wheel_rpm),
          trouble_codes: list(trouble_code),
          mileage_meters: %PropertyComponent{data: integer} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 7, 1, 0, 4, 0, 0, 0, 12>>
    iex> AutoApiL11.DiagnosticsState.from_bin(bin)
    %AutoApiL11.DiagnosticsState{mileage: %AutoApiL11.PropertyComponent{data: 12}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> state = %AutoApiL11.DiagnosticsState{mileage: %AutoApiL11.PropertyComponent{data: 12}}
    iex> AutoApiL11.DiagnosticsState.to_bin(state)
    <<1, 0, 7, 1, 0, 4, 0, 0, 0, 12>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
