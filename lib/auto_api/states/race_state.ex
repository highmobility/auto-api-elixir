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

  @type acceleration_type ::
          :longitudinal_acceleration
          | :lateral_acceleration
          | :front_lateral_acceleration
          | :rear_lateral_acceleration
  @type acceleration :: %{type: acceleration_type, g_force: float}
  @type active_inactive :: :inactive | :active
  @type gear_mode :: :manual | :park | :reverse | :neutral | :drive | :low_gear | :sport

  @doc """
  Race state
  """
  defstruct acceleration: [],
            understeering: 0,
            oversteering: 0,
            gas_pedal_position: 0,
            steering_angle: 0,
            brake_pressure: 0.0,
            yaw_rate: 0.0,
            rear_suspension_steering: 0,
            electronic_stability_program: :inactive,
            brake_torque_vectoring: [],
            gear_mode: :manual,
            selected_gear: 0,
            clutch_pedal_switch: :inactive,
            accelerator_pedal_idle_switch: :inactive,
            accelerator_pedal_kickdown_switch: :inactive,
            properties: []

  use AutoApi.State, spec_file: "specs/race.json"

  @type t :: %__MODULE__{
          acceleration: list(acceleration),
          understeering: integer,
          oversteering: integer,
          gas_pedal_position: integer,
          steering_angle: integer,
          brake_pressure: float,
          yaw_rate: float,
          rear_suspension_steering: integer,
          electronic_stability_program: active_inactive,
          brake_torque_vectoring: list(any),
          gear_mode: gear_mode,
          selected_gear: integer,
          clutch_pedal_switch: active_inactive,
          accelerator_pedal_idle_switch: active_inactive,
          accelerator_pedal_kickdown_switch: active_inactive,
          properties: list(atom)
        }

  @doc """
  Build state based on binary value

    iex> AutoApi.RaceState.from_bin(<<0x02, 1::integer-16, 100>>)
    %AutoApi.RaceState{understeering: 100}

    iex> AutoApi.RaceState.from_bin(<<0x01, 5::integer-16, 0x03,  9.9::float-32>>)
    %AutoApi.RaceState{acceleration: [%{g_force: 9.9, type: :rear_lateral_acceleration}]}

  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> properties = [:selected_gear]
    iex> AutoApi.RaceState.to_bin(%AutoApi.RaceState{selected_gear: 5, properties: properties})
    <<0x0C, 0, 1, 5>>

    iex> properties = AutoApi.RaceCapability.properties |> Enum.into(%{}) |> Map.values()
    iex> AutoApi.RaceState.to_bin(%AutoApi.RaceState{properties: properties})
    <<0x10, 0x0, 0x1, 0x0, 0x11, 0x0, 0x1, 0x0, 0x6, 0x0, 0x4, 0x0, 0x0, 0x0, 0x0, \
      0xF, 0x0, 0x1, 0x0, 0x9, 0x0, 0x1, 0x0, 0x4, 0x0, 0x1, 0x0, 0xB, 0x0, 0x1, \
      0x0, 0x3, 0x0, 0x1, 0x0, 0x8, 0x0, 0x1, 0x0, 0xC, 0x0, 0x1, 0x0, 0x5, 0x0, \
      0x1, 0x0, 0x2, 0x0, 0x1, 0x0, 0x7, 0x0, 0x4, 0x0, 0x0, 0x0, 0x0>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
