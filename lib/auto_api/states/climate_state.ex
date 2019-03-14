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
defmodule AutoApi.ClimateState do
  @moduledoc """
  StartStop state
  """

  alias AutoApi.{CommonData, PropertyComponent}

  defstruct inside_temperature: nil,
            outside_temperature: nil,
            driver_temperature_setting: nil,
            passenger_temperature_setting: nil,
            hvac_state: nil,
            defogging_state: nil,
            defrosting_state: nil,
            ionising_state: nil,
            defrosting_temperature: nil,
            hvac_weekday_starting_times: [],
            rear_temperature_setting: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "specs/climate.json"

  @type activity :: :inactive | :active
  @type hvac_weekday_starting_time :: %PropertyComponent{
          data: %{
            weekday: CommonData.weekday() | :automatic,
            hour: integer,
            minute: integer
          }
        }

  @type t :: %__MODULE__{
          inside_temperature: %PropertyComponent{data: float} | nil,
          outside_temperature: %PropertyComponent{data: float} | nil,
          driver_temperature_setting: %PropertyComponent{data: float} | nil,
          passenger_temperature_setting: %PropertyComponent{data: float} | nil,
          hvac_state: %PropertyComponent{data: CommonData.activity()} | nil,
          defogging_state: %PropertyComponent{data: CommonData.activity()} | nil,
          defrosting_state: %PropertyComponent{data: CommonData.activity()} | nil,
          ionising_state: %PropertyComponent{data: CommonData.activity()} | nil,
          defrosting_temperature: %PropertyComponent{data: float} | nil,
          hvac_weekday_starting_times: list(hvac_weekday_starting_time),
          rear_temperature_setting: %PropertyComponent{data: float} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> AutoApi.ClimateState.from_bin(<<1, 7::integer-16, 1, 0, 4, 65, 224, 0, 0>>)
    %AutoApi.ClimateState{inside_temperature: %AutoApi.PropertyComponent{data: 28.0}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.ClimateState{inside_temperature: %AutoApi.PropertyComponent{data: 28.00}}
    iex> AutoApi.ClimateState.to_bin(state)
    <<1, 7::integer-16, 1, 0, 4, 65, 224, 0, 0>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
