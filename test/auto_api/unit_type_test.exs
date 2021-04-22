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
defmodule AutoApi.UnitTypeStateTest do
  use ExUnit.Case, async: true
  doctest AutoApi.UnitType

  alias AutoApi.UnitType

  setup_all do
    specs = Jason.decode!(File.read!("specs/misc/unit_types.json"), keys: :atoms)

    {:ok, types: specs.measurement_types}
  end

  test "all/0" do
    assert UnitType.all() == [
             :acceleration,
             :angle,
             :angular_velocity,
             :duration,
             :electric_current,
             :electric_potential_difference,
             :energy,
             :energy_efficiency,
             :frequency,
             :fuel_efficiency,
             :illuminance,
             :length,
             :power,
             :pressure,
             :speed,
             :temperature,
             :torque,
             :volume
           ]
  end

  describe "id/1" do
    test "works for all measurement names as strings", %{types: types} do
      for type <- types do
        assert type.id == UnitType.id(type.name)
      end
    end

    test "works for all measurement names as atoms", %{types: types} do
      for type <- types do
        assert type.id == UnitType.id(String.to_atom(type.name))
      end
    end
  end

  describe "name/1" do
    test "works for all measurement ids", %{types: types} do
      for type <- types do
        assert type.name == to_string(UnitType.name(type.id))
      end
    end
  end

  describe "unit_id/2" do
    test "works for all measurement names", %{types: types} do
      for type <- types, unit <- type.unit_types do
        assert unit.id == UnitType.unit_id(String.to_atom(type.name), String.to_atom(unit.name))
      end
    end

    test "works for all measurement names as strings", %{types: types} do
      for type <- types, unit <- type.unit_types do
        assert unit.id == UnitType.unit_id(type.name, String.to_atom(unit.name))
      end
    end
  end

  describe "unit_name/2" do
    test "works for all measurement ids", %{types: types} do
      for type <- types, unit <- type.unit_types do
        assert String.to_atom(unit.name) == UnitType.unit_name(type.id, unit.id)
      end
    end
  end

  describe "units/1" do
    test "reads everything correctly from specs" do
      assert units = UnitType.units(:acceleration)
      assert length(units) == 2
      assert List.first(units) == :meters_per_second_squared

      assert units = UnitType.units(:angle)
      assert length(units) == 3
      assert List.first(units) == :degrees

      assert units = UnitType.units(:angular_velocity)
      assert length(units) == 3
      assert List.first(units) == :revolutions_per_minute

      assert units = UnitType.units(:duration)
      assert length(units) == 6
      assert List.first(units) == :seconds

      assert units = UnitType.units(:electric_current)
      assert length(units) == 3
      assert List.first(units) == :amperes

      assert units = UnitType.units(:electric_potential_difference)
      assert length(units) == 3
      assert List.first(units) == :volts

      assert units = UnitType.units(:energy)
      assert length(units) == 4
      assert List.first(units) == :joules

      assert units = UnitType.units(:energy_efficiency)
      assert length(units) == 2
      assert List.first(units) == :kwh_per_100_kilometers

      assert units = UnitType.units(:frequency)
      assert length(units) == 8
      assert List.first(units) == :hertz

      assert units = UnitType.units(:fuel_efficiency)
      assert length(units) == 3
      assert List.first(units) == :liters_per_100_kilometers

      assert units = UnitType.units(:illuminance)
      assert length(units) == 1
      assert List.first(units) == :lux

      assert units = UnitType.units(:length)
      assert length(units) == 12
      assert List.first(units) == :meters

      assert units = UnitType.units(:acceleration)
      assert length(units) == 2
      assert List.first(units) == :meters_per_second_squared

      assert units = UnitType.units(:power)
      assert length(units) == 5
      assert List.first(units) == :watts

      assert units = UnitType.units(:pressure)
      assert length(units) == 7
      assert List.first(units) == :pascals

      assert units = UnitType.units(:speed)
      assert length(units) == 4
      assert List.first(units) == :meters_per_second

      assert units = UnitType.units(:temperature)
      assert length(units) == 3
      assert List.first(units) == :kelvin

      assert units = UnitType.units(:torque)
      assert length(units) == 3
      assert List.first(units) == :newton_meters

      assert units = UnitType.units(:volume)
      assert length(units) == 14
      assert List.first(units) == :liters
    end

    test "works for all measurement ids", %{types: types} do
      for type <- types do
        units = Enum.map(type.unit_types, &String.to_atom(&1.name))
        assert units == UnitType.units(type.id)
      end
    end

    test "works for all measurement names", %{types: types} do
      for type <- types do
        units = Enum.map(type.unit_types, &String.to_atom(&1.name))
        assert units == UnitType.units(String.to_atom(type.name))
      end
    end

    test "works for all measurement names as strings", %{types: types} do
      for type <- types do
        units = Enum.map(type.unit_types, &String.to_atom(&1.name))
        assert units == UnitType.units(type.name)
      end
    end
  end
end
