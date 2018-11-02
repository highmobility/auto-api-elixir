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
defmodule AutoApi.VehicleStatusState do
  @moduledoc """
  VehicleStatus state
  """

  defstruct vin: "",
            powertrain: :unknown,
            model_name: "",
            name: "",
            license_plate: "",
            sales_designation: "",
            model_year: 00,
            color_name: "",
            power_in_kw: 0,
            number_of_doors: 0,
            number_of_seats: 0,
            engine_volume: 0.0,
            engine_max_torque: 0,
            gearbox: :manual,
            state: [],
            timestamp: nil,
            properties: []

  use AutoApi.State, spec_file: "specs/vehicle_status.json"

  @type powertrain ::
          :unknown | :all_electric | :combustion_engine | :phev | :hydrogen | :hydrogen_hybrid

  @type gearbox :: :manual | :automatic | :semi_automatic

  @type t :: %__MODULE__{
          vin: String.t(),
          powertrain: powertrain,
          model_name: String.t(),
          name: String.t(),
          license_plate: String.t(),
          sales_designation: String.t(),
          model_year: integer,
          color_name: String.t(),
          power_in_kw: integer,
          number_of_doors: integer,
          number_of_seats: integer,
          engine_volume: float,
          engine_max_torque: integer,
          gearbox: gearbox,
          state: list(any),
          timestamp: DateTime.t() | nil,
          properties: list(atom)
        }

  @doc """
  Build state based on binary value

    iex> vin = "JYE8GP0078A086432"
    iex> AutoApi.VehicleStatusState.from_bin(<<0x0E, 1::integer-16, 0x02, 0x02, 1::integer-16, 0x01, 0x01, byte_size(vin)::integer-16>> <> vin)
    %AutoApi.VehicleStatusState{vin: "JYE8GP0078A086432", powertrain: :all_electric, gearbox: :semi_automatic}

    iex> vin = "JYE8GP0078A086432"
    iex> model_name = "HM Concept"
    iex> AutoApi.VehicleStatusState.from_bin(<<0x03, byte_size(model_name)::integer-16>> <> model_name <> <<0x01, byte_size(vin)::integer-16>> <> vin)
    %AutoApi.VehicleStatusState{vin: "JYE8GP0078A086432", model_name: "HM Concept"}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin
    iex> AutoApi.VehicleStatusState.to_bin(%AutoApi.VehicleStatusState{vin: "vin", model_name: "model_name", properties: [:model_name, :vin]})
    <<0x03, 10::integer-16>> <> "model_name" <> <<0x01, 3::integer-16>> <> "vin"

  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
