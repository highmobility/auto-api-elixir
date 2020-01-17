defmodule AutoApi.ChargingState do
  @moduledoc """
  Keeps Charging state
  """

  alias AutoApi.PropertyComponent

  @type charging :: %PropertyComponent{
          data: :disconnected | :plugged_in | :charging | :charging_complete
        }
  @type charge_port_state :: %PropertyComponent{data: :closed | :open}
  @type charge_mode :: %PropertyComponent{data: :immediate | :timer_based | :inductive}
  @type plug_type :: %PropertyComponent{data: :type_1 | :type_2 | :ccs | :chademo}
  @type departure_time :: %PropertyComponent{
          data: %{state: :inactive | :active, time: %{hour: integer, minute: integer}}
        }
  @type reduction_time :: %PropertyComponent{
          data: %{start_stop: :start | :stop, time: %{hour: integer, minute: integer}}
        }
  @type timer_type :: :preferred_start_time | :preferred_end_time | :departure_date
  @type timer :: %PropertyComponent{
          data: %{
            timer_type: timer_type,
            date: DateTime.t()
          }
        }
  @type plugged_in :: %PropertyComponent{data: :disconnected | :plugged_in}
  @type charging_state :: %PropertyComponent{
          data:
            :not_charging
            | :charging
            | :charging_complete
            | :initialising
            | :charging_paused
            | :charging_error
        }
  @type charging_window_chosen :: %PropertyComponent{data: :not_chosen | :chosen}

  @doc """
  Charging state
  """
  defstruct estimated_range: nil,
            battery_level: nil,
            battery_current_ac: nil,
            battery_current_dc: nil,
            charger_voltage_ac: nil,
            charger_voltage_dc: nil,
            charge_limit: nil,
            time_to_complete_charge: nil,
            charging_rate_kw: nil,
            charge_port_state: nil,
            charge_mode: nil,
            max_charging_current: nil,
            plug_type: nil,
            charging_window_chosen: nil,
            departure_times: [],
            reduction_times: [],
            battery_temperature: nil,
            timers: [],
            plugged_in: nil,
            status: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "specs/charging.json"

  @type t :: %__MODULE__{
          estimated_range: %PropertyComponent{data: integer} | nil,
          battery_level: %PropertyComponent{data: float} | nil,
          battery_current_ac: %PropertyComponent{data: float} | nil,
          battery_current_dc: %PropertyComponent{data: float} | nil,
          charger_voltage_ac: %PropertyComponent{data: float} | nil,
          charger_voltage_dc: %PropertyComponent{data: float} | nil,
          charge_limit: %PropertyComponent{data: float} | nil,
          time_to_complete_charge: %PropertyComponent{data: integer} | nil,
          charging_rate_kw: %PropertyComponent{data: float} | nil,
          charge_port_state: charge_port_state | nil,
          charge_mode: charge_mode | nil,
          max_charging_current: %PropertyComponent{data: float} | nil,
          plug_type: plug_type | nil,
          charging_window_chosen: charging_window_chosen | nil,
          departure_times: list(departure_time),
          reduction_times: list(reduction_time),
          battery_temperature: %PropertyComponent{data: float} | nil,
          timers: list(timer),
          plugged_in: plugged_in | nil,
          status: charging_state | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<2, 0, 5, 1, 0, 2, 1, 44>>
    iex> AutoApi.ChargingState.from_bin(bin)
    %AutoApi.ChargingState{estimated_range: %AutoApi.PropertyComponent{data: 300}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> state = %AutoApi.ChargingState{estimated_range: %AutoApi.PropertyComponent{data: 300}}
    iex> AutoApi.ChargingState.to_bin(state)
    <<2, 0, 5, 1, 0, 2, 1, 44>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
