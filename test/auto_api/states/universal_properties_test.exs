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
defmodule AutoApi.UniversalPropertiesTest do
  use ExUnit.Case
  alias AutoApi.{DoorLocksState, DiagnosticsState}

  test "converts the state properties and the universal properties" do
    bin_state = <<0x04, 2::integer-16, 0x00, 0x01, 0xA2, 0, 8, 18, 6, 8, 16, 8, 2, 0, 120>>

    state = DoorLocksState.from_bin(bin_state)

    datetime = %DateTime{
      year: 2018,
      month: 06,
      day: 08,
      hour: 16,
      minute: 8,
      second: 2,
      utc_offset: 120,
      time_zone: "",
      zone_abbr: "",
      std_offset: 0
    }

    locks = [
      %{door_location: :front_left, position: :open}
    ]

    assert state == %DoorLocksState{positions: locks, timestamp: datetime}
  end

  describe "property timestamp" do
    test "converts binary value to state" do
      bin_state =
        <<0x01, 3::integer-16, 0, 0, 0x02, 0xA4, 9::integer-16, 18, 6, 8, 16, 8, 2, 0, 120, 0x01>>

      datetime = %DateTime{
        year: 2018,
        month: 06,
        day: 08,
        hour: 16,
        minute: 8,
        second: 2,
        utc_offset: 120,
        time_zone: "",
        zone_abbr: "",
        std_offset: 0
      }

      state = DiagnosticsState.from_bin(bin_state)

      assert is_map(state.property_timestamps)
      assert state.property_timestamps[:mileage] == datetime
    end

    test "converts binary value with multiple items to state" do
      # NOTE!: Currently elixir doesn't support converting all of the property_timestamps. if an item is repeated multiple times,
      # we only return the last property's timestamp
      bin_state =
        <<4, 0, 2, 2, 1, 4, 0, 2, 3, 0, 164, 0, 11, 18, 11, 28, 12, 56, 13, 0, 0, 4, 2, 1, 164, 0,
          11, 18, 11, 28, 13, 56, 13, 0, 0, 4, 3, 0>>

      state = DoorLocksState.from_bin(bin_state)

      assert state.positions ==
               [
                 %{door_location: :rear_left, position: :closed},
                 %{door_location: :rear_right, position: :open}
               ]

      assert state.property_timestamps[:positions] == %DateTime{
               year: 2018,
               month: 11,
               day: 28,
               hour: 13,
               minute: 56,
               second: 13,
               utc_offset: 0,
               time_zone: "Etc/UTC",
               zone_abbr: "UTC",
               std_offset: 0
             }
    end

    test "converts state to binary" do
      now = DateTime.utc_now()

      state = %DiagnosticsState{
        mileage: 100,
        property_timestamps: %{mileage: now},
        properties: [:mileage, :property_timestamps]
      }

      assert <<id, _size::integer-16, mileage::integer-24, timestamp_id,
               timestamp_size::integer-16, timestamp::binary-size(8),
               id>> = DiagnosticsState.to_bin(state)

      assert id == DiagnosticsState.property_id(:mileage)
      assert mileage == 100
      assert timestamp_id == 0xA4
      assert timestamp_size == 9

      assert timestamp ==
               <<now.year - 2000, now.month, now.day, now.hour, now.minute, now.second,
                 now.utc_offset::integer-16>>
    end

    test "converts state with multiple items to binary" do
      now = DateTime.utc_now()

      temperature = %{location: :rear_left, temperature: 10.0}

      state = %DiagnosticsState{
        tire_temperatures: [temperature],
        property_timestamps: %{tire_temperatures: [{now, temperature}]},
        properties: [:tire_temperatures, :property_timestamps]
      }

      assert <<timestamp_id, timestamp_size::integer-16, timestamp::binary-size(8),
               property_id_in_timestamp, property_data_in_timestamp::binary-size(5), property_id,
               5::integer-16, property_data::binary-size(5)>> = DiagnosticsState.to_bin(state)

      assert property_id == DiagnosticsState.property_id(:tire_temperatures)
      assert property_id == property_id_in_timestamp
      assert timestamp_id == 0xA4
      # timestamp size + property_id_size + tire_temperature size
      assert timestamp_size == 14

      assert timestamp ==
               <<now.year - 2000, now.month, now.day, now.hour, now.minute, now.second,
                 now.utc_offset::integer-16>>

      assert property_data == property_data_in_timestamp
    end

    test "converts DoorLocksState with multiple items to binary" do
      rear_right_datetime = %{DateTime.utc_now() | hour: 12}
      rear_left_datetime = %{rear_right_datetime | hour: 13}

      state = %AutoApi.DoorLocksState{
        positions: [
          %{door_location: :rear_right, position: :open},
          %{door_location: :rear_left, position: :closed}
        ],
        properties: [:property_timestamps, :positions],
        property_timestamps: %{
          positions: [
            {rear_right_datetime, %{door_location: :rear_right, position: :open}},
            {rear_left_datetime, %{door_location: :rear_left, position: :closed}}
          ]
        }
      }

      assert <<
               # rear_right_position
               4,
               2::integer-16,
               rear_right_position::binary-size(2),
               # rear_left_position
               4,
               2::integer-16,
               rear_left_position::binary-size(2),
               # rear_right_position timestamp
               0xA4,
               11::integer-16,
               rear_right_timestamp::binary-size(8),
               4,
               rear_right_position_in_timestamp::binary-size(2),
               # rear_left_position timestamp
               0xA4,
               11::integer-16,
               rear_left_timestamp::binary-size(8),
               4,
               rear_left_position_in_timestamp::binary-size(2)
             >> = DoorLocksState.to_bin(state)

      assert rear_right_position == <<2, 1>>
      assert rear_right_position == rear_right_position_in_timestamp
      assert rear_left_position == <<3, 0>>
      assert rear_left_position == rear_left_position_in_timestamp

      <<_y, _m, _d, hour, _::binary>> = rear_right_timestamp
      assert hour == rear_right_datetime.hour

      <<_y, _m, _d, hour, _::binary>> = rear_left_timestamp
      assert hour == rear_left_datetime.hour
    end
  end

  describe "put_with_timestamp/4" do
    test "converts signle value property with timestamp to binary" do
      now = DateTime.utc_now()

      state = %DiagnosticsState{}

      state = AutoApi.State.put_with_timestamp(state, :mileage, 101, now)

      assert state.mileage == 101
      assert state.property_timestamps[:mileage] == now
      assert state.properties == [:property_timestamps, :mileage]
    end

    test "converts multiple value property with timestamp to binary" do
      now = DateTime.utc_now()

      rear_left_temperature = %{location: :rear_left, temperature: 10.0}

      state = %DiagnosticsState{}

      state =
        AutoApi.State.put_with_timestamp(state, :tire_temperatures, rear_left_temperature, now)

      assert state.tire_temperatures == [rear_left_temperature]
      assert state.property_timestamps[:tire_temperatures] == [{now, rear_left_temperature}]
      assert state.properties == [:property_timestamps, :tire_temperatures]

      rear_right_temperature = %{location: :rear_right, temperature: 11.0}

      state =
        AutoApi.State.put_with_timestamp(state, :tire_temperatures, rear_right_temperature, now)

      assert state.tire_temperatures == [rear_right_temperature, rear_left_temperature]

      assert state.property_timestamps[:tire_temperatures] == [
               {now, rear_right_temperature},
               {now, rear_left_temperature}
             ]

      assert byte_size(DiagnosticsState.to_bin(state)) == 50
    end
  end

  describe "properties_failures" do
    test "converts bin failures to state" do
      # Put some UTF-8 weirdness in for good measure
      locks_desc = "Could not parse it (ノಠ益ಠ)ノ彡┻━┻"
      inside_desc = "Stuff happens ¯\_(ツ)_/¯"

      bin_state =
        <<4, 0, 2, 2, 1, 4, 0, 2, 3, 0, 165, byte_size(locks_desc) + 3::16, 3, 2,
          byte_size(locks_desc)::8, locks_desc::binary, 165, byte_size(inside_desc) + 3::16, 2, 4,
          byte_size(inside_desc)::8, inside_desc::binary>>

      state = DoorLocksState.from_bin(bin_state)

      assert length(state.positions) == 2

      assert state.properties_failures == %{
               locks: {:format_error, locks_desc},
               inside_locks: {:unknown, inside_desc}
             }
    end
  end
end
