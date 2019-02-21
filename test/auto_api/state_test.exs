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
defmodule AutoApi.StateTest do
  use ExUnit.Case
  alias AutoApi.{PropertyComponent, DiagnosticsState}

  describe "from_bin/1" do
    test "integer size 3" do
      spec = %{"type" => "integer", "size" => 3}
      mileage_prop = PropertyComponent.to_bin(%PropertyComponent{data: 16_777_215}, spec)

      state =
        DiagnosticsState.from_bin(<<0x01, byte_size(mileage_prop)::integer-16>> <> mileage_prop)

      assert state.mileage.data == 16_777_215
    end

    test "integer size 2" do
      spec = %{"type" => "integer", "size" => 2}
      mileage_prop = PropertyComponent.to_bin(%PropertyComponent{data: 65535}, spec)

      state =
        DiagnosticsState.from_bin(<<0x01, byte_size(mileage_prop)::integer-16>> <> mileage_prop)

      assert state.mileage.data == 65535
    end

    test "double size 8" do
      spec = %{"type" => "double", "size" => 8}
      fuel_level_prop = PropertyComponent.to_bin(%PropertyComponent{data: 1.1002}, spec)

      state =
        DiagnosticsState.from_bin(
          <<0x05, byte_size(fuel_level_prop)::integer-16>> <> fuel_level_prop
        )

      assert state.fuel_level.data == 1.1002
    end

    test "float size 4" do
      spec = %{"type" => "float", "size" => 4}

      engine_total_fuel_consumption_prop =
        PropertyComponent.to_bin(%PropertyComponent{data: 1.1002}, spec)

      state =
        DiagnosticsState.from_bin(
          <<0x13, byte_size(engine_total_fuel_consumption_prop)::integer-16>> <>
            engine_total_fuel_consumption_prop
        )

      assert state.engine_total_fuel_consumption.data == 1.1002
    end

    test "enum" do
      spec = %{
        "type" => "enum",
        "size" => 1,
        "values" => [%{"id" => 0, "name" => "low"}, %{"id" => 1, "name" => "filled"}]
      }

      anti_lock_braking_prop = PropertyComponent.to_bin(%PropertyComponent{data: :low}, spec)

      state =
        DiagnosticsState.from_bin(
          <<0x09, byte_size(anti_lock_braking_prop)::integer-16>> <> anti_lock_braking_prop
        )

      assert state.washer_fluid_level.data == :low
    end

    test "map" do
      spec = [
        %{"name" => "latitude", "type" => "double", "size" => 8},
        %{"name" => "longitude", "type" => "double", "size" => 8}
      ]

      prop_comp = %PropertyComponent{data: %{latitude: 52.442292, longitude: 13.176732}}
      bin_comp = PropertyComponent.map_to_bin(prop_comp, spec)

      state =
        AutoApi.VehicleLocationState.from_bin(
          <<0x04, byte_size(bin_comp)::integer-16, bin_comp::binary>>
        )

      assert state.coordinates == prop_comp
    end

    test "list of map" do
      spec = [
        %{
          "name" => "location",
          "size" => 1,
          "type" => "enum",
          "values" => [
            %{"id" => 0, "name" => "front_left"},
            %{"id" => 1, "name" => "front_right"},
            %{"id" => 2, "name" => "rear_right"},
            %{"id" => 3, "name" => "rear_left"}
          ]
        },
        %{
          "description" => "Tire pressure in BAR formatted in 4-bytes per IEEE 754",
          "name" => "pressure",
          "size" => 4,
          "type" => "float"
        }
      ]

      prop_comp = %PropertyComponent{data: %{location: :front_left, pressure: 22.034}}
      bin_comp = PropertyComponent.map_to_bin(prop_comp, spec)

      state = DiagnosticsState.from_bin(<<0x1A, byte_size(bin_comp)::integer-16>> <> bin_comp)

      assert state.tire_pressures == [prop_comp]
    end
  end

  describe "parse object" do
    test "when object is a map" do
      prop_name = :coordinates

      enum_values = [
        %{
          "description" => "Latitude in 8-bytes per IEEE 754",
          "name" => "latitude",
          "size" => 8,
          "type" => "double"
        },
        %{
          "description" => "Longitude in 8-bytes per IEEE 754",
          "name" => "longitude",
          "size" => 8,
          "type" => "double"
        }
      ]

      data_list = [64, 74, 66, 28, 222, 93, 24, 9, 64, 42, 195, 125, 65, 116, 62, 150]
      multiple = false

      {^prop_name, ^multiple, result} =
        AutoApi.State.parse_bin_property_to_list_helper(
          prop_name,
          enum_values,
          data_list,
          multiple
        )

      assert result == %{latitude: 52.516506, longitude: 13.381815}
    end
  end
end
