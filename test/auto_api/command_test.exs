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
  use ExUnit.Case, async: true
  doctest AutoApi.Command

  alias AutoApi.{Capability, PropertyComponent}

  describe "to_bin/2" do
    test "get works with all properties and all capabilities" do
      results =
        Capability.all()
        |> Enum.map(&{&1, &1.command})
        |> Enum.map(fn {cap, command} ->
          prop_names = Enum.map(cap.properties, &elem(&1, 1))

          {cap, apply(command, :to_bin, [:get, prop_names])}
        end)

      assert Enum.all?(results, &assert_get_command/1)
    end

    defp assert_get_command({capability, binary_command}) do
      preamble = <<0x0B, capability.identifier()::binary, 0x00>>

      command_bin =
        capability.properties
        |> Enum.map(&elem(&1, 0))
        |> Enum.reduce(<<>>, &(&2 <> <<&1>>))

      assert <<preamble::binary, command_bin::binary>> == binary_command
    end

    test "set works" do
      # Generating values automatically is hard so for now I'll just test manually one
      timestamp = ~U[2019-07-26 15:36:33.867501Z]
      properties = [inside_locks_state: %PropertyComponent{data: :unlocked, timestamp: timestamp}]

      bin_command = AutoApi.DoorsCommand.to_bin(:set, properties)

      assert bin_command ==
               <<0x0B, 0, 32, 1, 5, 0, 15, 1, 0, 1, 0, 2, 0, 8, 0, 0, 1, 108, 46, 237, 55, 75>>
    end

    test "setter supports constants" do
      assert <<0x0B, 0, 34, 1, 1, 0, 4, 1, 0, 1, 0>> == AutoApi.WakeUpCommand.to_bin(:wake_up)
    end
  end

  describe "to_bin/2 and from_bin/2 are inverse functions" do
    test ":set" do
      properties = [
        speed: %PropertyComponent{
          data: {88, :miles_per_hour},
          timestamp: ~U[2019-07-18 13:58:40.489Z]
        },
        tire_pressures: %PropertyComponent{data: %{location: :front_left, pressure: {2.3, :bars}}},
        tire_pressures: %PropertyComponent{data: %{location: :rear_right, pressure: {2.5, :bars}}},
        engine_rpm: %PropertyComponent{failure: %{reason: :format_error, description: "Error"}}
      ]

      assert cmd_bin = AutoApi.DiagnosticsCommand.to_bin(:set, properties)
      assert {:set, properties} == AutoApi.DiagnosticsCommand.from_bin(cmd_bin)
    end

    test ":get" do
      properties = [:speed, :tire_pressures, :engine_rpm]

      assert cmd_bin = AutoApi.DiagnosticsCommand.to_bin(:get, properties)
      assert {:get, properties} == AutoApi.DiagnosticsCommand.from_bin(cmd_bin)
    end

    test ":get with no properties" do
      assert cmd_bin = AutoApi.DiagnosticsCommand.to_bin(:get)
      assert {:get, []} == AutoApi.DiagnosticsCommand.from_bin(cmd_bin)
    end
  end

  describe "execute/2" do
    test "set overwrites multiple properties" do
      state = %AutoApi.DoorsState{
        locks: [
          %PropertyComponent{data: %{location: :front_right, lock_state: :locked}},
          %PropertyComponent{data: %{location: :front_left, lock_state: :locked}}
        ],
        positions: [
          %PropertyComponent{data: %{location: :rear_left, position: :open}}
        ]
      }

      command_props = [
        locks: %PropertyComponent{data: %{location: :rear_right, lock_state: :locked}},
        locks: %PropertyComponent{data: %{location: :rear_left, lock_state: :locked}}
      ]

      command_bin = AutoApi.DoorsCommand.to_bin(:set, command_props)

      assert AutoApi.DoorsCommand.execute(state, command_bin) ==
               %AutoApi.DoorsState{
                 locks: [
                   %PropertyComponent{data: %{location: :rear_right, lock_state: :locked}},
                   %PropertyComponent{data: %{location: :rear_left, lock_state: :locked}}
                 ],
                 positions: [
                   %PropertyComponent{data: %{location: :rear_left, position: :open}}
                 ]
               }
    end
  end
end
