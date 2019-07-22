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
defmodule AutoApi.CommandTest do
  use ExUnit.Case
  doctest AutoApi.Command

  alias AutoApi.Capability

  describe "to_bin/2" do
    test "get/2 works with all properties and all capabilities" do
      results =
        Capability.all()
        |> Enum.map(&{&1, &1.command})
        |> Enum.reject(fn {_cap, command} -> command == AutoApi.NotImplemented end)
        |> Enum.map(fn {cap, command} ->
          prop_names = Enum.map(cap.properties, &elem(&1, 1))

          {cap, apply(command, :to_bin, [:get, prop_names])}
        end)

      assert Enum.all?(results, &assert_get_command/1)
    end

    defp assert_get_command({capability, binary_command}) do
      preamble = <<capability.identifier() :: binary, 0x00>>
      command_bin =
        capability.properties
        |> Enum.map(&elem(&1, 0))
        |> Enum.reduce(<<>>, &(&2 <> <<&1>>))

      assert <<preamble :: binary, command_bin :: binary>> == binary_command
    end
  end
end
