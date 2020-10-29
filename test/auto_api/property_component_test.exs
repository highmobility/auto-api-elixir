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
  use ExUnit.Case, async: true
  use PropCheck

  alias AutoApi.{PropertyComponent, State}

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

    property "converts timestamp to bin" do
      forall data <- [timestamp: datetime(), datetime: datetime()] do
        spec = %{"type" => "timestamp"}

        prop_bin =
          PropertyComponent.to_bin(
            %PropertyComponent{data: data[:timestamp], timestamp: data[:datetime]},
            spec
          )

        prop_comp = PropertyComponent.to_struct(prop_bin, spec)

        assert prop_comp.data == data[:timestamp]
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
        "enum_values" => [
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

    test "converts enum to bin when it's nil" do
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
          %PropertyComponent{failure: %{reason: :unknown, description: ""}},
          spec
        )

      prop_comp = PropertyComponent.to_struct(prop_bin, spec)

      refute prop_comp.data
      refute prop_comp.timestamp
      assert prop_comp.failure == %{reason: :unknown, description: ""}
    end

    test "converts capability_state to bin" do
      datetime = DateTime.utc_now()

      spec = %{
        "type" => "types.capability_state"
      }

      state =
        AutoApi.DoorsState.base()
        |> State.put(:positions,
          data: %{
            location: :front_left,
            position: :closed
          }
        )

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

    test "converts custom type to bin" do
      spec = %{
        "type" => "custom",
        "size" => 2,
        "id" => 0xFD,
        "items" => [
          %{
            "name" => "location",
            "size" => 1,
            "type" => "enum",
            "enum_values" => [
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
      }

      prop_comp = %PropertyComponent{data: %{location: :front_left, pressure: 22.034}}
      bin_comp = PropertyComponent.to_bin(prop_comp, spec)

      assert bin_comp == <<1, 5::integer-16, 0x00, 65, 176, 69, 162>>

      assert PropertyComponent.to_struct(bin_comp, spec) == prop_comp
    end

    test "converts unit type to bin" do
      spec = %{
        "type" => "unit.length",
        "size" => 10,
        "id" => 0xFD
      }

      prop_comp = %PropertyComponent{data: %{value: 186, unit: :centimeters}}
      bin_comp = PropertyComponent.to_bin(prop_comp, spec)

      assert bin_comp == <<0x01, 0x00, 0x0A, 0x12, 0x02, 186::float-64>>

      assert PropertyComponent.to_struct(bin_comp, spec) == prop_comp
    end

    property "converts custom value with string to bin" do
      forall data <- [id: integer_2(), text: utf8(), datetime: datetime()] do
        spec = %{
          "type" => "custom",
          "items" => [
            %{
              "name" => "id",
              "size" => 2,
              "type" => "integer"
            },
            %{
              "name" => "text",
              "type" => "string"
            }
          ]
        }

        text = data[:text]
        text_size = byte_size(text)
        id = data[:id]

        prop_comp = %PropertyComponent{
          data: %{id: id, text: text},
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

    property "converts custom value with strings to bin" do
      forall data <- [enum: oneof([:foo, :bar, :baz]), text: utf8(), datetime: datetime()] do
        spec = %{
          "type" => "custom",
          "items" => [
            %{
              "name" => "enum",
              "type" => "enum",
              "size" => 1,
              "enum_values" => [
                %{"id" => 0, "name" => "foo"},
                %{"id" => 1, "name" => "bar"},
                %{"id" => 2, "name" => "baz"}
              ]
            },
            %{
              "name" => "key",
              "type" => "string"
            },
            %{
              "name" => "value",
              "type" => "string"
            }
          ]
        }

        enum = data[:enum]
        text = data[:text]
        text_size = byte_size(text)

        prop_comp = %PropertyComponent{
          data: %{enum: enum, key: text, value: text},
          timestamp: data[:datetime]
        }

        bin_comp = PropertyComponent.to_bin(prop_comp, spec)

        bin_data = <<1, text_size::integer-16, text::binary, text_size::integer-16, text::binary>>

        bin_data_size_org = byte_size(bin_data)

        assert <<1, bin_data_size::integer-16, bin_data::binary-size(bin_data_size), _::binary>> =
                 bin_comp

        assert bin_data_size_org == bin_data_size

        assert PropertyComponent.to_struct(bin_comp, spec) == prop_comp
      end
    end

    property "converts custom value with only strings to bin" do
      forall data <- [text: utf8(), datetime: datetime()] do
        spec = %{
          "type" => "custom",
          "items" => [
            %{
              "name" => "key",
              "type" => "string"
            },
            %{
              "name" => "value",
              "type" => "string"
            }
          ]
        }

        text = data[:text]
        text_size = byte_size(text)

        prop_comp = %PropertyComponent{
          data: %{key: text, value: text},
          timestamp: data[:datetime]
        }

        bin_comp = PropertyComponent.to_bin(prop_comp, spec)

        bin_data = <<text_size::integer-16, text::binary, text_size::integer-16, text::binary>>

        bin_data_size_org = byte_size(bin_data)

        assert <<1, bin_data_size::integer-16, bin_data::binary-size(bin_data_size), _::binary>> =
                 bin_comp

        assert bin_data_size_org == bin_data_size

        assert PropertyComponent.to_struct(bin_comp, spec) == prop_comp
      end
    end

    property "converts embedded custom value with strings to bin" do
      forall data <- [id: integer_2(), text: utf8(), datetime: datetime()] do
        spec = %{
          "type" => "custom",
          "items" => [
            %{
              "name" => "id",
              "size" => 2,
              "type" => "integer"
            },
            %{
              "name" => "map",
              "type" => "custom",
              "items" => [
                %{
                  "name" => "key",
                  "type" => "string"
                },
                %{
                  "name" => "value",
                  "type" => "string"
                }
              ]
            }
          ]
        }

        text = data[:text]
        text_size = byte_size(text)
        id = data[:id]

        prop_comp = %PropertyComponent{
          data: %{id: id, map: %{key: text, value: text}},
          timestamp: data[:datetime]
        }

        bin_comp = PropertyComponent.to_bin(prop_comp, spec)

        map_data_size = (text_size + 2) * 2 + 2

        bin_data =
          <<id::integer-16, map_data_size::integer-16, text_size::integer-16, text::binary,
            text_size::integer-16, text::binary>>

        bin_data_size_org = byte_size(bin_data)

        assert <<1, bin_data_size::integer-16, bin_data::binary-size(bin_data_size), _::binary>> =
                 bin_comp

        assert bin_data_size_org == bin_data_size

        assert PropertyComponent.to_struct(bin_comp, spec) == prop_comp
      end
    end

    @days [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday, :automatic]
    property "converts multiple custom value with complex data to bin" do
      forall data <- [
               hour: integer(0, 23),
               minute: integer(0, 59),
               weekday: oneof(@days),
               datetime: datetime()
             ] do
        spec = %{
          "id" => 11,
          "multiple" => true,
          "type" => "custom",
          "items" => [
            %{
              "enum_values" => [
                %{"id" => 0, "name" => "monday"},
                %{"id" => 1, "name" => "tuesday"},
                %{"id" => 2, "name" => "wednesday"},
                %{"id" => 3, "name" => "thursday"},
                %{"id" => 4, "name" => "friday"},
                %{"id" => 5, "name" => "saturday"},
                %{"id" => 6, "name" => "sunday"},
                %{"id" => 7, "name" => "automatic"}
              ],
              "name" => "weekday",
              "size" => 1,
              "type" => "enum"
            },
            %{
              "items" => [
                %{
                  "name" => "hour",
                  "size" => 1,
                  "type" => "uinteger"
                },
                %{
                  "name" => "minute",
                  "size" => 1,
                  "type" => "uinteger"
                }
              ],
              "name" => "time",
              "size" => 2,
              "type" => "custom"
            }
          ],
          "size" => 3
        }

        weekday = data[:weekday]
        weekday_bin = Enum.find_index(@days, &(&1 == weekday))
        hour = data[:hour]
        minute = data[:minute]

        prop_comp = %PropertyComponent{
          data: %{weekday: weekday, time: %{hour: hour, minute: minute}},
          timestamp: data[:datetime]
        }

        bin_comp = PropertyComponent.to_bin(prop_comp, spec)

        bin_data = <<weekday_bin, hour, minute>>
        bin_data_size_org = byte_size(bin_data)

        assert <<1, bin_data_size::integer-16, bin_data::binary-size(bin_data_size), _::binary>> =
                 bin_comp

        assert bin_data_size_org == bin_data_size

        assert PropertyComponent.to_struct(bin_comp, spec) == prop_comp
      end
    end

    property "converts multiple custom value with complex external data to bin" do
      forall data <- [
               hour: integer(0, 23),
               minute: integer(0, 59),
               weekday: oneof(@days),
               datetime: datetime()
             ] do
        spec = %{
          "multiple" => true,
          "type" => "types.hvac_weekday_starting_time"
        }

        weekday = data[:weekday]
        weekday_bin = Enum.find_index(@days, &(&1 == weekday))
        hour = data[:hour]
        minute = data[:minute]

        prop_comp = %PropertyComponent{
          data: %{weekday: weekday, time: %{hour: hour, minute: minute}},
          timestamp: data[:datetime]
        }

        bin_comp = PropertyComponent.to_bin(prop_comp, spec)

        bin_data = <<weekday_bin, hour, minute>>
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
            "enum_values" => [
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

    property "converts availability to bin" do
      forall data <- [
               update_rate: update_rate(),
               rate_limit: rate_limit(),
               applies_per: applies_per(),
               timestamp: datetime()
             ] do
        spec = %{"type" => "integer", "size" => 3}

        component = %PropertyComponent{
          timestamp: data[:timestamp],
          availability: %{
            update_rate: data[:update_rate],
            rate_limit: data[:rate_limit],
            applies_per: data[:applies_per]
          }
        }

        prop_bin = PropertyComponent.to_bin(component, spec)
        prop_comp = PropertyComponent.to_struct(prop_bin, spec)

        assert prop_comp.data == component.data
        assert prop_comp.timestamp == component.timestamp
        assert prop_comp.failure == component.failure
        assert prop_comp.availability == component.availability
      end
    end

    property "converts availability to bin when spec is map" do
      forall data <- [
               update_rate: update_rate(),
               rate_limit: rate_limit(),
               applies_per: applies_per(),
               timestamp: datetime()
             ] do
        spec = [
          %{
            "name" => "location",
            "size" => 1,
            "type" => "enum",
            "enum_values" => [
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
          availability: %{
            update_rate: data[:update_rate],
            rate_limit: data[:rate_limit],
            applies_per: data[:applies_per]
          }
        }

        prop_bin = PropertyComponent.to_bin(component, spec)
        prop_comp = PropertyComponent.to_struct(prop_bin, spec)

        assert prop_comp.data == component.data
        assert prop_comp.timestamp == component.timestamp
        assert prop_comp.failure == component.failure
        assert prop_comp.availability == component.availability
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

  def update_rate do
    oneof([:trip_high, :trip, :trip_start_end, :trip_end, :unknown, :not_available, :on_change])
  end

  def rate_limit do
    let [value <- float(), unit <- oneof(AutoApi.UnitType.units(:frequency))] do
      %{value: value, unit: unit}
    end
  end

  def applies_per do
    oneof([:app, :vehicle])
  end
end
