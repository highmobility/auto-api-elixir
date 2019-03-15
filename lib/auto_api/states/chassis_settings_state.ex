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
defmodule AutoApi.ChassisSettingsState do
  @moduledoc """
  ChassisSettings state
  """

  alias AutoApi.{CommonData, PropertyComponent}

  defstruct driving_mode: nil,
            sport_chrono: nil,
            current_spring_rates: [],
            maximum_spring_rates: [],
            minimum_spring_rates: [],
            current_chassis_position: nil,
            maximum_chassis_position: nil,
            minimum_chassis_position: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "specs/chassis_settings.json"

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

    iex> AutoApi.ChassisSettingsState.from_bin(<<1, 4::integer-16, 1, 0, 1, 0>>)
    %AutoApi.ChassisSettingsState{driving_mode: %AutoApi.PropertyComponent{data: :regular}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.ChassisSettingsState{driving_mode: %AutoApi.PropertyComponent{data: :regular}}
    iex> AutoApi.ChassisSettingsState.to_bin(state)
    <<1, 4::integer-16, 1, 0, 1, 0>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
