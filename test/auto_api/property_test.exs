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
defmodule AutoApiL12.PropertyTest do
  use ExUnit.Case, async: true
  use PropCheck

  import AutoApiL12.PropCheckFixtures

  alias AutoApiL12.Property

  describe "to_bin/3 & to_struct/3" do
    property "converts uint24 to bin" do
      forall data <- [integer: uint(3), datetime: datetime()] do
        spec = %{"type" => "uinteger", "size" => 3}

        prop_bin =
          Property.to_bin(
            %Property{data: data[:integer], timestamp: data[:datetime]},
            spec
          )

        prop_comp = Property.to_struct(prop_bin, spec)
        assert prop_comp.data == data[:integer]
        assert prop_comp.timestamp == data[:datetime]
        assert prop_comp.failure == nil
      end
    end

    property "converts uint16 to bin" do
      forall data <- [integer: uint(2), datetime: datetime()] do
        spec = %{"type" => "uinteger", "size" => 2}

        prop_bin =
          Property.to_bin(
            %Property{data: data[:integer], timestamp: data[:datetime]},
            spec
          )

        prop_comp = Property.to_struct(prop_bin, spec)
        assert prop_comp.data == data[:integer]
        assert prop_comp.timestamp == data[:datetime]
        assert prop_comp.failure == nil
      end
    end

    property "converts uint8 to bin" do
      forall data <- [integer: uint(1), datetime: datetime()] do
        spec = %{"type" => "uinteger", "size" => 1}

        prop_bin =
          Property.to_bin(
            %Property{data: data[:integer], timestamp: data[:datetime]},
            spec
          )

        prop_comp = Property.to_struct(prop_bin, spec)
        assert prop_comp.data == data[:integer]
        assert prop_comp.timestamp == data[:datetime]
        assert prop_comp.failure == nil
      end
    end

    property "converts int16 to bin" do
      forall data <- [integer: int(2), datetime: datetime()] do
        spec = %{"type" => "integer", "size" => 2}

        prop_bin =
          Property.to_bin(
            %Property{data: data[:integer], timestamp: data[:datetime]},
            spec
          )

        prop_comp = Property.to_struct(prop_bin, spec)
        assert prop_comp.data == data[:integer]
        assert prop_comp.timestamp == data[:datetime]
        assert prop_comp.failure == nil
      end
    end

    property "converts int8 to bin" do
      forall data <- [integer: int(1), datetime: datetime()] do
        spec = %{"type" => "integer", "size" => 1}

        prop_bin =
          Property.to_bin(
            %Property{data: data[:integer], timestamp: data[:datetime]},
            spec
          )

        prop_comp = Property.to_struct(prop_bin, spec)
        assert prop_comp.data == data[:integer]
        assert prop_comp.timestamp == data[:datetime]
        assert prop_comp.failure == nil
      end
    end

    property "converts double64 to bin" do
      forall data <- [double: float(), datetime: datetime()] do
        spec = %{"type" => "double", "size" => 8}

        prop_bin =
          Property.to_bin(
            %Property{data: data[:double], timestamp: data[:datetime]},
            spec
          )

        prop_comp = Property.to_struct(prop_bin, spec)
        assert prop_comp.data == data[:double]
        assert prop_comp.timestamp == data[:datetime]
        assert prop_comp.failure == nil
      end
    end

    property "converts string to bin" do
      forall data <- [string: utf8(), datetime: datetime()] do
        spec = %{"type" => "string"}

        prop_bin =
          Property.to_bin(
            %Property{data: data[:string], timestamp: data[:datetime]},
            spec
          )

        prop_comp = Property.to_struct(prop_bin, spec)

        assert prop_comp.data == data[:string]
        assert prop_comp.timestamp == data[:datetime]
        assert prop_comp.failure == nil
      end
    end

    property "converts timestamp to bin" do
      forall data <- [timestamp: datetime(), datetime: datetime()] do
        spec = %{"type" => "timestamp"}

        prop_bin =
          Property.to_bin(
            %Property{data: data[:timestamp], timestamp: data[:datetime]},
            spec
          )

        prop_comp = Property.to_struct(prop_bin, spec)

        assert prop_comp.data == data[:timestamp]
        assert prop_comp.timestamp == data[:datetime]
        assert prop_comp.failure == nil
      end
    end

    property "converts enum to bin" do
      forall data <- [enum: oneof([:low, :filled]), datetime: datetime()] do
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
          Property.to_bin(
            %Property{data: data[:enum], timestamp: data[:datetime]},
            spec
          )

        prop_comp = Property.to_struct(prop_bin, spec)

        assert prop_comp.data == data[:enum]
        assert prop_comp.timestamp == data[:datetime]
        assert prop_comp.failure == nil
      end
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
        Property.to_bin(
          %Property{failure: %{reason: :unknown, description: ""}},
          spec
        )

      prop_comp = Property.to_struct(prop_bin, spec)

      refute prop_comp.data
      refute prop_comp.timestamp
      assert prop_comp.failure == %{reason: :unknown, description: ""}
    end

    property "converts capability_state to bin" do
      forall data <- [command: command(), datetime: datetime()] do
        spec = %{
          "type" => "types.capability_state"
        }

        prop_bin =
          Property.to_bin(
            %Property{data: data[:command], timestamp: data[:datetime]},
            spec
          )

        prop_comp = Property.to_struct(prop_bin, spec)

        assert prop_comp.data == data[:command]
        assert prop_comp.timestamp == data[:datetime]
        assert prop_comp.failure == nil
      end
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

      prop_comp = %Property{data: %{location: :front_left, pressure: 22.034}}
      bin_comp = Property.to_bin(prop_comp, spec)

      assert bin_comp == <<1, 5::integer-16, 0x00, 65, 176, 69, 162>>

      assert Property.to_struct(bin_comp, spec) == prop_comp
    end

    property "converts unit type to bin" do
      forall data <- [unit_with_type: unit_with_type(), id: int(1), datetime: datetime()] do
        {unit_type, unit_value} = data[:unit_with_type]

        spec = %{
          "type" => "unit.#{unit_type}",
          "size" => 10,
          "id" => data[:id]
        }

        prop_bin =
          Property.to_bin(
            %Property{data: unit_value, timestamp: data[:datetime]},
            spec
          )

        prop_comp = Property.to_struct(prop_bin, spec)

        assert prop_comp.data == unit_value
        assert prop_comp.timestamp == data[:datetime]
        assert prop_comp.failure == nil
      end
    end

    property "converts custom value with string to bin" do
      forall data <- [id: int(2), text: utf8(), datetime: datetime()] do
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

        prop_comp = %Property{
          data: %{id: id, text: text},
          timestamp: data[:datetime]
        }

        bin_comp = Property.to_bin(prop_comp, spec)

        bin_data = <<id::integer-16, text_size::integer-16, text::binary>>
        bin_data_size = byte_size(bin_data)

        assert <<1, ^bin_data_size::integer-16, ^bin_data::binary-size(bin_data_size), _::binary>> =
                 bin_comp

        assert Property.to_struct(bin_comp, spec) == prop_comp
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
        enum_bin = Enum.find_index([:foo, :bar, :baz], &(&1 == enum))
        text = data[:text]
        text_size = byte_size(text)

        prop_comp = %Property{
          data: %{enum: enum, key: text, value: text},
          timestamp: data[:datetime]
        }

        bin_comp = Property.to_bin(prop_comp, spec)

        bin_data =
          <<enum_bin, text_size::integer-16, text::binary, text_size::integer-16, text::binary>>

        bin_data_size = byte_size(bin_data)

        assert <<1, ^bin_data_size::integer-16, ^bin_data::binary-size(bin_data_size), _::binary>> =
                 bin_comp

        assert Property.to_struct(bin_comp, spec) == prop_comp
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

        prop_comp = %Property{
          data: %{key: text, value: text},
          timestamp: data[:datetime]
        }

        bin_comp = Property.to_bin(prop_comp, spec)

        bin_data = <<text_size::integer-16, text::binary, text_size::integer-16, text::binary>>
        bin_data_size = byte_size(bin_data)

        assert <<1, ^bin_data_size::integer-16, ^bin_data::binary-size(bin_data_size), _::binary>> =
                 bin_comp

        assert Property.to_struct(bin_comp, spec) == prop_comp
      end
    end

    property "converts embedded custom value with strings to bin" do
      forall data <- [id: int(2), text: utf8(), datetime: datetime()] do
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

        prop_comp = %Property{
          data: %{id: id, map: %{key: text, value: text}},
          timestamp: data[:datetime]
        }

        bin_comp = Property.to_bin(prop_comp, spec)

        # map_data_size = (text_size + 2) * 2 + 2
        map_data_size = (text_size + 2) * 2

        bin_data =
          <<id::integer-16, map_data_size::integer-16, text_size::integer-16, text::binary,
            text_size::integer-16, text::binary>>

        bin_data_size = byte_size(bin_data)

        assert <<1, ^bin_data_size::integer-16, ^bin_data::binary-size(bin_data_size), _::binary>> =
                 bin_comp

        assert Property.to_struct(bin_comp, spec) == prop_comp
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

        prop_comp = %Property{
          data: %{weekday: weekday, time: %{hour: hour, minute: minute}},
          timestamp: data[:datetime]
        }

        bin_comp = Property.to_bin(prop_comp, spec)

        bin_data = <<weekday_bin, hour, minute>>
        bin_data_size = byte_size(bin_data)

        assert <<1, ^bin_data_size::integer-16, ^bin_data::binary-size(bin_data_size), _::binary>> =
                 bin_comp

        assert Property.to_struct(bin_comp, spec) == prop_comp
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

        prop_comp = %Property{
          data: %{weekday: weekday, time: %{hour: hour, minute: minute}},
          timestamp: data[:datetime]
        }

        bin_comp = Property.to_bin(prop_comp, spec)

        bin_data = <<weekday_bin, hour, minute>>
        bin_data_size = byte_size(bin_data)

        assert <<1, ^bin_data_size::integer-16, ^bin_data::binary-size(bin_data_size), _::binary>> =
                 bin_comp

        assert Property.to_struct(bin_comp, spec) == prop_comp
      end
    end

    property "converts failure to bin" do
      forall data <- [description: utf8(), reason: error_reason(), timestamp: datetime()] do
        spec = %{"type" => "integer", "size" => 3}

        component = %Property{
          timestamp: data[:timestamp],
          failure: %{reason: data[:reason], description: data[:description]}
        }

        prop_bin = Property.to_bin(component, spec)
        prop_comp = Property.to_struct(prop_bin, spec)

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

        component = %Property{
          timestamp: data[:timestamp],
          failure: %{reason: data[:reason], description: data[:description]}
        }

        prop_bin = Property.to_bin(component, spec)
        prop_comp = Property.to_struct(prop_bin, spec)

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

        component = %Property{
          timestamp: data[:timestamp],
          availability: %{
            update_rate: data[:update_rate],
            rate_limit: data[:rate_limit],
            applies_per: data[:applies_per]
          }
        }

        prop_bin = Property.to_bin(component, spec)
        prop_comp = Property.to_struct(prop_bin, spec)

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

        component = %Property{
          timestamp: data[:timestamp],
          availability: %{
            update_rate: data[:update_rate],
            rate_limit: data[:rate_limit],
            applies_per: data[:applies_per]
          }
        }

        prop_bin = Property.to_bin(component, spec)
        prop_comp = Property.to_struct(prop_bin, spec)

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

  def update_rate do
    oneof([:trip_high, :trip, :trip_start_end, :trip_end, :unknown, :not_available, :on_change])
  end

  def rate_limit do
    let [value <- float(), unit <- oneof(AutoApiL12.UnitType.units(:frequency))] do
      %{value: value, unit: unit}
    end
  end

  def applies_per do
    oneof([:app, :vehicle])
  end
end
