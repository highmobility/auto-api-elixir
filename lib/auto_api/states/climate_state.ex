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

  alias AutoApi.CommonData

  defstruct inside_temperature: nil,
            outside_temperature: nil,
            driver_temperature_setting: nil,
            passenger_temperature_setting: nil,
            hvac_state: nil,
            defogging_state: nil,
            defrosting_state: nil,
            ionising_state: nil,
            defrosting_temperature: nil,
            auto_hvac_profile: [],
            timestamp: nil,
            properties: []

  use AutoApi.State, spec_file: "specs/climate.json"

  @type activity :: :inactive | :active

  @type t :: %__MODULE__{
          inside_temperature: float | nil,
          timestamp: DateTime.t() | nil,
          properties: list(atom)
        }

  @doc """
  Build state based on binary value

    iex> AutoApi.ClimateState.from_bin(<<0x01, 4::integer-16, 37.0::float-32>>)
    %AutoApi.ClimateState{inside_temperature: 37.0}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin
    iex> AutoApi.ClimateState.to_bin(%AutoApi.ClimateState{inside_temperature: 28.00, properties: [:inside_temperature]})
    <<1, 4::integer-16, 28.00::float-32>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
