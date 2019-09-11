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
defmodule AutoApi.CapabilityHelperTest do
  use ExUnit.Case

  alias AutoApi.CapabilityHelper

  test "extract_setters_data/1" do
    specs = %{
      "properties" => [
        %{
          "id" => 0x01,
          "name" => "foo"
        },
        %{
          "id" => 0x02,
          "name" => "bar"
        },
        %{
          "id" => 0x03,
          "name" => "baz"
        }
      ],
      "setters" => [
        %{
          "name" => "foo_bar",
          "mandatory" => [0x01, 0x02]
        },
        %{
          "name" => "foo_bar_baz",
          "mandatory" => [0x01],
          "optional" => [0x02, 0x03]
        }
      ]
    }

    assert [foo_bar, foo_bar_baz] = CapabilityHelper.extract_setters_data(specs)
    assert foo_bar == {:foo_bar, {[:foo, :bar], []}}
    assert foo_bar_baz == {:foo_bar_baz, {[:foo], [:bar, :baz]}}
  end

  test "reject_extra_properties/2" do
    properties = [foo: %{}, bar: %{}, baz: %{}]

    assert [foo: %{}, bar: %{}] ==
             CapabilityHelper.reject_extra_properties(properties, ~w(foo bar)a)

    assert [baz: %{}] == CapabilityHelper.reject_extra_properties(properties, ~w(baz)a)
  end

  test "raise_for_missing_properties/2" do
    properties = [foo: %{}, bar: %{}]

    assert CapabilityHelper.raise_for_missing_properties(properties, [:bar])

    assert_raise ArgumentError, fn ->
      CapabilityHelper.raise_for_missing_properties(properties, [:foo, :baz])
    end
  end
end
