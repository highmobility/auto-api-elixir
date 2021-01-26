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

    test "set works" do
      # Generating values automatically is hard so for now I'll just test manually one
      timestamp = ~U[2019-07-26 15:36:33.867501Z]
      properties = [inside_locks_state: %PropertyComponent{data: :unlocked, timestamp: timestamp}]

      bin_command = AutoApi.DoorsCommand.to_bin(:set, properties)

      assert bin_command ==
               <<0x0C, 0, 32, 1, 5, 0, 15, 1, 0, 1, 0, 2, 0, 8, 0, 0, 1, 108, 46, 237, 55, 75>>
    end

    test "setter supports constants" do
      assert <<0x0C, 0, 34, 1, 1, 0, 4, 1, 0, 1, 0>> == AutoApi.WakeUpCommand.to_bin(:wake_up)
    end

    test "get_availability works with all properties and all capabilities" do
      results =
        Capability.all()
        |> Enum.map(&{&1, &1.command})
        |> Enum.map(fn {cap, command} ->
          prop_names = Enum.map(cap.properties, &elem(&1, 1))

          {cap, apply(command, :to_bin, [:get_availability, prop_names])}
        end)

      assert Enum.all?(results, &assert_get_availability_command/1)
    end

    defp assert_get_command({capability, binary_command}) do
      preamble = <<0x0C, capability.identifier()::binary, 0x00>>

      assert_binary_command(preamble, capability, binary_command)
    end

    defp assert_get_availability_command({capability, binary_command}) do
      preamble = <<0x0C, capability.identifier()::binary, 0x02>>

      assert_binary_command(preamble, capability, binary_command)
    end

    defp assert_binary_command(preamble, capability, binary_command) do
      command_bin =
        capability.properties()
        |> Enum.map(&elem(&1, 0))
        |> Enum.reduce(<<>>, &(&2 <> <<&1>>))

      assert <<preamble::binary, command_bin::binary>> == binary_command
    end
  end

  describe "to_bin/2 and from_bin/2 are inverse functions" do
    test ":set" do
      properties = [
        speed: %PropertyComponent{
          data: %{value: 88, unit: :miles_per_hour},
          timestamp: ~U[2019-07-18 13:58:40.489Z]
        },
        tire_pressures: %PropertyComponent{
          data: %{location: :front_left, pressure: %{value: 2.3, unit: :bars}}
        },
        tire_pressures: %PropertyComponent{
          data: %{location: :rear_right, pressure: %{value: 2.5, unit: :bars}}
        },
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

    test ":get_availability" do
      properties = [:speed, :tire_pressures, :engine_rpm]

      assert cmd_bin = AutoApi.DiagnosticsCommand.to_bin(:get_availability, properties)
      assert {:get_availability, properties} == AutoApi.DiagnosticsCommand.from_bin(cmd_bin)
    end

    test ":get_availability with no properties" do
      assert cmd_bin = AutoApi.DiagnosticsCommand.to_bin(:get_availability)
      assert {:get_availability, []} == AutoApi.DiagnosticsCommand.from_bin(cmd_bin)
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

    test "get_availability works" do
      mileage_availability = %{
        update_rate: :trip,
        rate_limit: %{value: 2, unit: :times_per_day},
        applies_per: :app
      }

      speed_availability = %{
        update_rate: :on_change,
        rate_limit: %{value: 1, unit: :hertz},
        applies_per: :vehicle
      }

      state = %AutoApi.DiagnosticsState{
        mileage: %AutoApi.PropertyComponent{availability: mileage_availability},
        speed: %AutoApi.PropertyComponent{availability: speed_availability}
      }

      command_bin = AutoApi.DiagnosticsCommand.to_bin(:get_availability, [:speed])

      assert AutoApi.DiagnosticsCommand.execute(state, command_bin) ==
               %AutoApi.DiagnosticsState{
                 speed: %AutoApi.PropertyComponent{availability: speed_availability}
               }
    end
  end
end
