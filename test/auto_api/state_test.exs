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
      mileage_prop = PropertyComponent.to_bin(%PropertyComponent{data: 16_777_215}, :integer, 3)

      state =
        DiagnosticsState.from_bin(<<0x01, byte_size(mileage_prop)::integer-16>> <> mileage_prop)

      assert state.mileage.data == 16_777_215
    end

    test "integer size 2" do
      mileage_prop = PropertyComponent.to_bin(%PropertyComponent{data: 65535}, :integer, 2)

      state =
        DiagnosticsState.from_bin(<<0x01, byte_size(mileage_prop)::integer-16>> <> mileage_prop)

      assert state.mileage.data == 65535
    end

    test "double size 8" do
      fuel_level_prop = PropertyComponent.to_bin(%PropertyComponent{data: 1.1002}, :double, 8)

      state =
        DiagnosticsState.from_bin(
          <<0x05, byte_size(fuel_level_prop)::integer-16>> <> fuel_level_prop
        )

      assert state.fuel_level.data == 1.1002
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
