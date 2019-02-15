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
    property "convert uint24 to bin" do
      forall data <- [integer: integer_3(), datetime: datetime()] do
        prop_bin =
          PropertyComponent.to_bin(
            %PropertyComponent{data: data[:integer], timestamp: data[:datetime]},
            :integer,
            3
          )

        prop_comp = PropertyComponent.to_struct(prop_bin, :integer, 3)
        assert prop_comp.data == data[:integer]
        assert prop_comp.timestamp == data[:datetime]
        assert prop_comp.failure == nil
      end
    end

    property "convert uint16 to bin" do
      forall data <- [integer: integer_2(), datetime: datetime()] do
        prop_bin =
          PropertyComponent.to_bin(
            %PropertyComponent{data: data[:integer], timestamp: data[:datetime]},
            :integer,
            2
          )

        prop_comp = PropertyComponent.to_struct(prop_bin, :integer, 3)
        assert prop_comp.data == data[:integer]
        assert prop_comp.timestamp == data[:datetime]
        assert prop_comp.failure == nil
      end
    end

    property "convert double64 to bin" do
      forall data <- [double: double_8(), datetime: datetime()] do
        prop_bin =
          PropertyComponent.to_bin(
            %PropertyComponent{data: data[:double], timestamp: data[:datetime]},
            :double,
            8
          )

        prop_comp = PropertyComponent.to_struct(prop_bin, :double, 8)
        assert prop_comp.data == data[:double]
        assert prop_comp.timestamp == data[:datetime]
        assert prop_comp.failure == nil
      end
    end
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
