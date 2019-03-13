# AutoAPI
# Copyright (C) 2018 High-Mobility GmbH
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see http://www.gnu.org/licenses/.
#
# Please inquire about commercial licensing options at
# licensing@high-mobility.com
defmodule AutoApi.RaceState do
  @moduledoc """
  Keeps Race state

  """

  alias AutoApi.{CommonData, PropertyComponent}

  @type acceleration_type ::
          :longitudinal_acceleration
          | :lateral_acceleration
          | :front_lateral_acceleration
          | :rear_lateral_acceleration
  @type acceleration :: %PropertyComponent{data: %{type: acceleration_type, g_force: float}}
  @type gear_mode :: :manual | :park | :reverse | :neutral | :drive | :low_gear | :sport
  @type axle :: :front_axle | :rear_axle
  @type brake_torque_vectoring :: %PropertyComponent{
          data: %{axle: axle, vectoring: CommonData.activity()}
        }

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
            clutch_pedal_switch: nil,
            accelerator_pedal_idle_switch: nil,
            accelerator_pedal_kickdown_switch: nil,
            timestamp: nil,
            properties: [],
            property_timestamps: %{}

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
          clutch_pedal_switch: %PropertyComponent{data: CommonData.activity()} | nil,
          accelerator_pedal_idle_switch: %PropertyComponent{data: CommonData.activity()} | nil,
          accelerator_pedal_kickdown_switch:
            %PropertyComponent{data: CommonData.activity()} | nil,
          timestamp: DateTime.t() | nil,
          properties: list(atom),
          property_timestamps: map()
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

    iex> state = %AutoApi.RaceState{understeering: %AutoApi.PropertyComponent{data: 22.17}, properties: [:understeering]}
    iex> AutoApi.RaceState.to_bin(state)
    <<2, 0, 11, 1, 0, 8, 64, 54, 43, 133, 30, 184, 81, 236>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
