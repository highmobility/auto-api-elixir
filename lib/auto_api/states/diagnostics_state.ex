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
defmodule AutoApi.DiagnosticsState do
  @moduledoc """
  Keeps Diagnostics state

  engine_oil_temperature: Engine oil temperature in Celsius, whereas can be negative
  """

  @type fluid_level :: :low | :filled
  @type position :: :front_left | :front_right | :rear_right | :rear_left
  @type tire_data :: %{position: position, pressure: float}
  @doc """
  Diagnostics state

  * `speed`: The car speed in km/h, whereas can be negative
  * `mileage`: The car speed in km/h, whereas can be negative
  * `engine_rpm`: The car speed in km/h, whereas can be negative
  * `fuel_level`: Fuel level percentage between 0-100
  * `washer_fluid_level`: value could be :low or :filled
  * `engine_oil_temperature`: Engine oil temperature in Celsius, whereas can be negative
  * `tires`: List of tire pressures
  """
  defstruct mileage: 0,
            engine_oil_temperature: 0,
            speed: 0,
            engine_rpm: 0,
            fuel_level: 0,
            washer_fluid_level: :low,
            tire: []

  use AutoApi.State, spec_file: "specs/diagnostics.json"

  @type t :: %__MODULE__{
          mileage: integer,
          engine_oil_temperature: integer,
          speed: integer,
          engine_rpm: integer,
          fuel_level: integer,
          washer_fluid_level: fluid_level,
          tire: list(tire_data)
        }

  alias AutoApi.CommonData

  @doc """
  Build state based on binary value

  iex> AutoApi.DiagnosticsState.from_bin(<<0x01, 2::integer-16, 100::integer-16>>)
  %AutoApi.DiagnosticsState{mileage: 100}
  iex> AutoApi.DiagnosticsState.from_bin(<<0x01, 2::integer-16, 100::integer-16, 0x02, 2::integer-16, 26::integer-16>>)
  %AutoApi.DiagnosticsState{mileage: 100, engine_oil_temperature: 26}

  iex> AutoApi.DiagnosticsState.from_bin(<<0xA, 13::integer-16, 0x03, 4.0::float-32, 8.0::float-32, 16.0::float-32>>)
  %AutoApi.DiagnosticsState{tire: [%{tire_position: <<3>>, tire_pressure: <<64, 128, 0, 0>>, tire_temperature: <<65, 0, 0, 0>>, wheel_rpm: <<65, 128, 0, 0>>}]}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_properties(bin, %__MODULE__{})
  end

  defp fluid_to_bin(:low), do: 0x00
  defp fluid_to_bin(:filled), do: 0x01

  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    <<
      state.mileage::integer-24,
      state.engine_oil_temperature::integer-16,
      state.speed::integer-16,
      state.engine_rpm::integer-16,
      state.fuel_level,
      fluid_to_bin(state.washer_fluid_level),
      length(state.tires),
      atom_tire_to_bin(state.tires)::binary
    >>
  end

  defp atom_tire_to_bin(<<>>), do: <<>>

  defp atom_tire_to_bin(tiers) do
    tiers
    |> Enum.map(fn %{position: position, pressure: pressure} ->
      <<CommonData.atom_position_to_bin(position), pressure::float-32>>
    end)
    |> Enum.reduce(<<>>, fn x, acc -> acc <> x end)
  end
end
