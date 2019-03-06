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
defmodule AutoApi.PropertyComponentTest do
  use ExUnit.Case
  use PropCheck

  alias AutoApi.PropertyComponent

  describe "to_bin/3 & to_struct/3" do
    property "converts uint24 to bin" do
      forall data <- [integer: integer_3(), datetime: datetime()] do
        spec = %{"type" => "integer", "size" => 3}

        prop_bin =
          PropertyComponent.to_bin(
            %PropertyComponent{data: data[:integer], timestamp: data[:datetime]},
            spec
          )

        prop_comp = PropertyComponent.to_struct(prop_bin, spec)
        assert prop_comp.data == data[:integer]
        assert prop_comp.timestamp == data[:datetime]
        assert prop_comp.failure == nil
      end
    end

    property "converts uint16 to bin" do
      forall data <- [integer: integer_2(), datetime: datetime()] do
        spec = %{"type" => "integer", "size" => 2}

        prop_bin =
          prop_bin =
          PropertyComponent.to_bin(
            %PropertyComponent{data: data[:integer], timestamp: data[:datetime]},
            spec
          )

        prop_comp = PropertyComponent.to_struct(prop_bin, spec)
        assert prop_comp.data == data[:integer]
        assert prop_comp.timestamp == data[:datetime]
        assert prop_comp.failure == nil
      end
    end

    property "converts double64 to bin" do
      forall data <- [double: double_8(), datetime: datetime()] do
        spec = %{"type" => "double", "size" => 8}

        prop_bin =
          PropertyComponent.to_bin(
            %PropertyComponent{data: data[:double], timestamp: data[:datetime]},
            spec
          )

        prop_comp = PropertyComponent.to_struct(prop_bin, spec)
        assert prop_comp.data == data[:double]
        assert prop_comp.timestamp == data[:datetime]
        assert prop_comp.failure == nil
      end
    end

    property "converts string to bin" do
      forall data <- [string: utf8(), datetime: datetime()] do
        spec = %{"type" => "string"}

        prop_bin =
          PropertyComponent.to_bin(
            %PropertyComponent{data: data[:string], timestamp: data[:datetime]},
            spec
          )

        prop_comp = PropertyComponent.to_struct(prop_bin, spec)

        assert prop_comp.data == data[:string]
        assert prop_comp.timestamp == data[:datetime]
        assert prop_comp.failure == nil
      end
    end

    test "converts enum to bin" do
      datetime = DateTime.utc_now()

      spec = %{
        "type" => "enum",
        "name" => "brake_fluid_level",
        "size" => 1,
        "values" => [
          %{"id" => 0x00, "name" => "low"},
          %{"id" => 1, "name" => "filled"}
        ]
      }

      prop_bin =
        PropertyComponent.to_bin(
          %PropertyComponent{data: :low, timestamp: datetime},
          spec
        )

      prop_comp = PropertyComponent.to_struct(prop_bin, spec)

      assert prop_comp.data == :low
      assert DateTime.to_unix(prop_comp.timestamp) == DateTime.to_unix(datetime)
      assert prop_comp.failure == nil
    end

    test "converts capability_state to bin" do
      datetime = DateTime.utc_now()

      spec = %{
        "type" => "capability_state"
      }

      state =
        AutoApi.DoorLocksState.base()
        |> AutoApi.DoorLocksState.append_property(:positions, %{
          door_location: :front_left,
          position: :closed
        })

      prop_bin =
        PropertyComponent.to_bin(
          %PropertyComponent{data: state, timestamp: datetime},
          spec
        )

      prop_comp = PropertyComponent.to_struct(prop_bin, spec)

      assert prop_comp.data == state
      assert DateTime.to_unix(prop_comp.timestamp) == DateTime.to_unix(datetime)
      assert prop_comp.failure == nil
    end

    test "converts map to bin" do
      spec = [
        %{
          "name" => "location",
          "size" => 1,
          "type" => "enum",
          "values" => [
            %{"id" => 0, "name" => "front_left"},
            %{"id" => 1, "name" => "front_right"},
            %{"id" => 2, "name" => "rear_right"},
            %{"id" => 3, "name" => "rear_left"}
          ]
        },
        %{
          "description" => "Tire pressure in BAR formatted in 4-bytes per IEEE 754",
          "name" => "pressure",
          "size" => 4,
          "type" => "float"
        }
      ]

      prop_comp = %PropertyComponent{data: %{location: :front_left, pressure: 22.034}}
      bin_comp = PropertyComponent.to_bin(prop_comp, spec)

      assert bin_comp == <<1, 5::integer-16, 0x00, 65, 176, 69, 162>>

      assert PropertyComponent.to_struct(bin_comp, spec) == prop_comp
    end

    property "converts map with string to bin" do
      forall data <- [id: integer_2(), text: utf8(), datetime: datetime()] do
        spec = [
          %{
            "name" => "id",
            "size" => 2,
            "type" => "integer"
          },
          %{
            "name" => "text_size",
            "size" => 2,
            "type" => "integer"
          },
          %{
            "name" => "text",
            "type" => "string"
          }
        ]

        text = data[:text]
        text_size = byte_size(text)
        id = data[:id]

        prop_comp = %PropertyComponent{
          data: %{id: id, text_size: text_size, text: text},
          timestamp: data[:datetime]
        }

        bin_comp = PropertyComponent.to_bin(prop_comp, spec)

        bin_data = <<id::integer-16, text_size::integer-16, text::binary>>
        bin_data_size_org = byte_size(bin_data)

        assert <<1, bin_data_size::integer-16, bin_data::binary-size(bin_data_size), _::binary>> =
                 bin_comp

        assert bin_data_size_org == bin_data_size

        assert PropertyComponent.to_struct(bin_comp, spec) == prop_comp
      end
    end

    property "converts failure to bin" do
      forall data <- [description: utf8(), reason: error_reason(), timestamp: datetime()] do
        spec = %{"type" => "integer", "size" => 3}

        component = %PropertyComponent{
          timestamp: data[:timestamp],
          failure: %{reason: data[:reason], description: data[:description]}
        }

        prop_bin = PropertyComponent.to_bin(component, spec)
        prop_comp = PropertyComponent.to_struct(prop_bin, spec)

        assert prop_comp.data == component.data
        assert prop_comp.timestamp == component.timestamp
        assert prop_comp.failure == component.failure
      end
    end

    property "converts failure to bin when spec is map" do
      forall data <- [description: utf8(), reason: error_reason(), timestamp: datetime()] do
        spec = [
          %{
            "name" => "location",
            "size" => 1,
            "type" => "enum",
            "values" => [
              %{"id" => 0, "name" => "front_left"},
              %{"id" => 1, "name" => "front_right"},
              %{"id" => 2, "name" => "rear_right"},
              %{"id" => 3, "name" => "rear_left"}
            ]
          },
          %{
            "description" => "Tire pressure in BAR formatted in 4-bytes per IEEE 754",
            "name" => "pressure",
            "size" => 4,
            "type" => "float"
          }
        ]

        component = %PropertyComponent{
          timestamp: data[:timestamp],
          failure: %{reason: data[:reason], description: data[:description]}
        }

        prop_bin = PropertyComponent.to_bin(component, spec)
        prop_comp = PropertyComponent.to_struct(prop_bin, spec)

        assert prop_comp.data == component.data
        assert prop_comp.timestamp == component.timestamp
        assert prop_comp.failure.reason == component.failure.reason
        assert prop_comp.failure.description == component.failure.description
      end
    end
  end

  def error_reason do
    oneof([:rate_limit, :execution_timeout, :format_error, :unauthorised, :unknown, :pending])
  end

  def integer_3 do
    oneof([0, range(10_000, 100_000), range(16_770_215, 16_777_215), 16_777_215])
  end

  def integer_2 do
    oneof([0, range(1000, 10_000), range(60_535, 65_535), 65_535])
  end

  def double_8 do
    oneof([0.0, float()])
  end

  def datetime do
    let timestamp <-
          oneof([
            nil,
            0,
            range(1, 1_000_000),
            range(1_550_226_102_909, 9_550_226_102_909),
            9_999_999_999_999
          ]) do
      case timestamp && DateTime.from_unix(timestamp, :millisecond) do
        {:ok, datetime} -> datetime
        _ -> nil
      end
    end
  end
end
