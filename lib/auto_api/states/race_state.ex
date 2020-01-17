defmodule AutoApi.RaceState do
  @moduledoc """
  Keeps Race state

  """

  alias AutoApi.{CommonData, PropertyComponent}

  @type direction ::
          :longitudinal
          | :lateral
          | :front_lateral
          | :rear_lateral
  @type acceleration :: %PropertyComponent{data: %{direction: direction, g_force: float}}
  @type gear_mode :: :manual | :park | :reverse | :neutral | :drive | :low_gear | :sport
  @type axle :: :front_axle | :rear_axle
  @type brake_torque_vectoring :: %PropertyComponent{
          data: %{axle: axle, vectoring: CommonData.activity()}
        }
  @type vehicle_moving :: :moving | :not_moving

  @doc """
  Race state
  """
  defstruct accelerations: [],
            understeering: nil,
            oversteering: nil,
            gas_pedal_position: nil,
            steering_angle: nil,
            brake_pressure: nil,
            yaw_rate: nil,
            rear_suspension_steering: nil,
            electronic_stability_program: nil,
            brake_torque_vectorings: [],
            gear_mode: nil,
            selected_gear: nil,
            brake_pedal_position: nil,
            brake_pedal_switch: nil,
            clutch_pedal_switch: nil,
            accelerator_pedal_idle_switch: nil,
            accelerator_pedal_kickdown_switch: nil,
            vehicle_moving: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "specs/race.json"

  @type t :: %__MODULE__{
          accelerations: list(acceleration),
          understeering: %PropertyComponent{data: float} | nil,
          oversteering: %PropertyComponent{data: float} | nil,
          gas_pedal_position: %PropertyComponent{data: float} | nil,
          steering_angle: %PropertyComponent{data: integer} | nil,
          brake_pressure: %PropertyComponent{data: float} | nil,
          yaw_rate: %PropertyComponent{data: float} | nil,
          rear_suspension_steering: %PropertyComponent{data: integer} | nil,
          electronic_stability_program: %PropertyComponent{data: CommonData.activity()} | nil,
          brake_torque_vectorings: list(brake_torque_vectoring),
          gear_mode: %PropertyComponent{data: gear_mode} | nil,
          selected_gear: %PropertyComponent{data: integer} | nil,
          brake_pedal_position: %PropertyComponent{data: float} | nil,
          brake_pedal_switch: %PropertyComponent{data: CommonData.activity()} | nil,
          clutch_pedal_switch: %PropertyComponent{data: CommonData.activity()} | nil,
          accelerator_pedal_idle_switch: %PropertyComponent{data: CommonData.activity()} | nil,
          accelerator_pedal_kickdown_switch:
            %PropertyComponent{data: CommonData.activity()} | nil,
          vehicle_moving: %PropertyComponent{data: vehicle_moving} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<2, 0, 11, 1, 0, 8, 64, 54, 43, 133, 30, 184, 81, 236>>
    iex> AutoApi.RaceState.from_bin(bin)
    %AutoApi.RaceState{understeering: %AutoApi.PropertyComponent{data: 22.17}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> state = %AutoApi.RaceState{understeering: %AutoApi.PropertyComponent{data: 22.17}}
    iex> AutoApi.RaceState.to_bin(state)
    <<2, 0, 11, 1, 0, 8, 64, 54, 43, 133, 30, 184, 81, 236>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
