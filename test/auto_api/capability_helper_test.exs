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
defmodule AutoApiL11.CapabilityHelperTest do
  use ExUnit.Case

  alias AutoApiL11.CapabilityHelper, as: CH

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
          "name" => "foo",
          "constants" => [
            %{
              "property_id" => 0x01,
              "value" => [57, 11, 134, 11, 222, 2, 49, 17]
            }
          ]
        },
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

    assert [foo, foo_bar, foo_bar_baz] = CH.extract_setters_data(specs)
    assert foo == {:foo, {[], [], [foo: <<57, 11, 134, 11, 222, 2, 49, 17>>]}}
    assert foo_bar == {:foo_bar, {[:foo, :bar], [], []}}
    assert foo_bar_baz == {:foo_bar_baz, {[:foo], [:bar, :baz], []}}
  end

  test "extract_state_properties/1" do
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
      "state" => "all"
    }

    assert [:foo, :bar, :baz] == CH.extract_state_properties(specs)
    assert [:foo] == CH.extract_state_properties(Map.put(specs, "state", [0x01]))
    assert [] == CH.extract_state_properties(Map.delete(specs, "state"))
  end
end
