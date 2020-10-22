# AutoAPI
# The MIT License
#
# Copyright (c) 2018- High-Mobility GmbH (https://high-mobility.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
defmodule AutoApi.RaceState do
  @moduledoc """
  Keeps Race state

  """

  alias AutoApi.{CommonData, State, UnitType}

  use AutoApi.State, spec_file: "race.json"

  @type direction ::
          :longitudinal
          | :lateral
          | :front_lateral
          | :rear_lateral
  @type acceleration :: %{direction: direction(), acceleration: UnitType.acceleration()}
  @type gear_mode :: :manual | :park | :reverse | :neutral | :drive | :low_gear | :sport
  @type brake_torque_vectoring :: %{
          axle: CommonData.location_longitudinal(),
          vectoring: CommonData.activity()
        }
  @type vehicle_moving :: :moving | :not_moving

  @type t :: %__MODULE__{
          accelerations: State.multiple_property(acceleration()),
          understeering: State.property(float),
          oversteering: State.property(float),
          gas_pedal_position: State.property(float),
          steering_angle: State.property(UnitType.angle()),
          brake_pressure: State.property(UnitType.pressure()),
          yaw_rate: State.property(UnitType.angular_velocity()),
          rear_suspension_steering: State.property(UnitType.angle()),
          electronic_stability_program: State.property(CommonData.activity()),
          brake_torque_vectorings: State.multiple_property(brake_torque_vectoring),
          gear_mode: State.property(gear_mode),
          selected_gear: State.property(integer),
          brake_pedal_position: State.property(float),
          brake_pedal_switch: State.property(CommonData.activity()),
          clutch_pedal_switch: State.property(CommonData.activity()),
          accelerator_pedal_idle_switch: State.property(CommonData.activity()),
          accelerator_pedal_kickdown_switch: State.property(CommonData.activity()),
          vehicle_moving: State.property(vehicle_moving)
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
