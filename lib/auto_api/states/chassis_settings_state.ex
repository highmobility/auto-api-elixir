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
defmodule AutoApiL12.ChassisSettingsState do
  @moduledoc """
  ChassisSettings state
  """

  alias AutoApiL12.{CommonData, State, UnitType}

  use AutoApiL12.State, spec_file: "chassis_settings.json"

  @type sport_chrono :: :inactive | :active | :reset
  @type spring_rate :: %{
          value: UnitType.torque(),
          axle: CommonData.location_longitudinal()
        }

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

    iex> AutoApiL12.ChassisSettingsState.from_bin(<<1, 4::integer-16, 1, 0, 1, 0>>)
    %AutoApiL12.ChassisSettingsState{driving_mode: %AutoApiL12.Property{data: :regular}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApiL12.ChassisSettingsState{driving_mode: %AutoApiL12.Property{data: :regular}}
    iex> AutoApiL12.ChassisSettingsState.to_bin(state)
    <<1, 4::integer-16, 1, 0, 1, 0>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
