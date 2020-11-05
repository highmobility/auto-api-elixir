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
defmodule AutoApiL11.CapabilityTest do
  use ExUnit.Case
  doctest AutoApiL11.Capability

  alias AutoApiL11.Capability

  test "all/0 does not contain duplicates" do
    assert Enum.uniq(Capability.all()) == Capability.all()
  end

  test "all capabilities have different IDs" do
    ids = Enum.map(Capability.all(), &apply(&1, :identifier, []))

    assert Enum.uniq(ids) == ids
  end

  test "get_by_name/1 works with all capabilities" do
    capabilities = Capability.all()

    assert Enum.all?(capabilities, fn cap ->
             Capability.get_by_name(cap.name) == cap
           end)
  end

  test "get_by_id/1 works with all capabilities" do
    capabilities = Capability.all()

    assert Enum.all?(capabilities, fn cap ->
             Capability.get_by_id(cap.identifier) == cap
           end)
  end

  test "list_capabilities/0 returns legacy format" do
    cap_ids = Enum.into(Capability.all(), %{}, &{&1.identifier, &1})

    assert cap_ids == Capability.list_capabilities()
  end
end
