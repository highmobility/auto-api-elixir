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
defmodule AutoApiL11.CommandHelperTest do
  use ExUnit.Case

  import ExUnit.CaptureLog

  alias AutoApiL11.CommandHelper, as: CH

  test "inject_constants/2" do
    base_data = :crypto.strong_rand_bytes(12)
    constants = [foo: <<1, 2, 3>>, bar: <<4, 5, 6>>]
    properties = [{:foo, 0x00}, {:bar, 0x01}]

    assert <<base_data::binary, 0, 0, 6, 1, 0, 3, 1, 2, 3, 1, 0, 6, 1, 0, 3, 4, 5, 6>> ==
             CH.inject_constants(base_data, constants, properties)
  end

  test "reject_extra_properties/2" do
    properties = [foo: %{}, bar: %{}, baz: %{}]

    foobar = fn ->
      assert [baz: %{}] == CH.reject_extra_properties(properties, ~w(baz)a)
    end

    baz = fn ->
      assert [foo: %{}, bar: %{}] ==
               CH.reject_extra_properties(properties, ~w(foo bar)a)
    end

    assert capture_log(foobar) =~ "Ignoring foo"
    assert capture_log(foobar) =~ "Ignoring bar"
    assert capture_log(baz) =~ "Ignoring baz"
  end

  test "raise_for_missing_properties/2" do
    properties = [foo: %{}, bar: %{}]

    assert CH.raise_for_missing_properties(properties, [:bar])

    assert_raise ArgumentError, fn ->
      CH.raise_for_missing_properties(properties, [:foo, :baz])
    end
  end
end
