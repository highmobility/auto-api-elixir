defmodule AutoApi.DashboardLightsState do
  @moduledoc """
  Keeps Charging state
  """

  alias AutoApi.PropertyComponent

  @doc """
  Dashboard Lights state
  """
  defstruct dashboard_lights: [],
            timestamp: nil

  use AutoApi.State, spec_file: "dashboard_lights.json"

  @type light_name ::
          :high_beam
          | :low_beam
          | :hazard_warning
          | :brake_failure
          | :hatch_open
          | :fuel_level
          | :engine_coolant_temperature
          | :battery_charging_condition
          | :engine_oil
          | :position_lights
          | :front_fog_light
          | :rear_fog_light
          | :park_heating
          | :engine_indicator
          | :service_call
          | :transmission_fluid_temperature
          | :transmission_failure
          | :anti_lock_brake_failure
          | :worn_brake_linings
          | :windscreen_washer_fluid
          | :tire_failure
          | :engine_oil_level
          | :engine_coolant_level
          | :steering_failure
          | :esc_indication
          | :brake_lights
          | :adblue_level
          | :fuel_filter_diff_pressure
          | :seat_belt
          | :advanced_braking
          | :acc
          | :trailer_connected
          | :airbag
          | :esc_switched_off
          | :lane_departure_warning_off

  @type state :: :inactive | :info | :yellow | :red
  @type dashboard_lights :: %PropertyComponent{data: %{name: light_name, state: state}}
  @type t :: %__MODULE__{
          dashboard_lights: list(dashboard_lights),
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 5, 1, 0, 2, 1, 1>>
    iex> AutoApi.DashboardLightsState.from_bin(bin)
    %AutoApi.DashboardLightsState{dashboard_lights: [%AutoApi.PropertyComponent{data: %{name: :low_beam, state: :info}}]}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> state = %AutoApi.DashboardLightsState{dashboard_lights: [%AutoApi.PropertyComponent{data: %{name: :low_beam, state: :info}}]}
    iex> AutoApi.DashboardLightsState.to_bin(state)
    <<1, 0, 5, 1, 0, 2, 1, 1>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
