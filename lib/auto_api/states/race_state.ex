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
            understeering: nil,
            oversteering: nil,
            gas_pedal_position: nil,
            steering_angle: nil,
            brake_pressure: nil,
            yaw_rate: nil,
            rear_suspension_steering: nil,
            electronic_stability_program: nil,
            brake_torque_vectoring: [],
            gear_mode: nil,
            selected_gear: nil,
            clutch_pedal_switch: nil,
            accelerator_pedal_idle_switch: nil,
            accelerator_pedal_kickdown_switch: nil,
            properties: []

  use AutoApi.State, spec_file: "specs/race.json"

  @type t :: %__MODULE__{
          acceleration: list(acceleration),
          understeering: integer | nil,
          oversteering: integer | nil,
          gas_pedal_position: integer | nil,
          steering_angle: integer | nil,
          brake_pressure: float | nil,
          yaw_rate: float | nil,
          rear_suspension_steering: integer | nil,
          electronic_stability_program: active_inactive | nil,
          brake_torque_vectoring: list(any),
          gear_mode: gear_mode | nil,
          selected_gear: integer | nil,
          clutch_pedal_switch: active_inactive | nil,
          accelerator_pedal_idle_switch: active_inactive | nil,
          accelerator_pedal_kickdown_switch: active_inactive | nil,
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
    <<>>
    iex> AutoApi.RaceState.to_bin(%AutoApi.RaceState{gas_pedal_position: 10, properties: properties})
    <<4, 0, 1, 10>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
