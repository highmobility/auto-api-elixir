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
defmodule AutoApiL12.CommonDataStateTest do
  use ExUnit.Case, async: true

  alias AutoApiL12.CommonData

  test "convert binary to IEEE 754" do
    assert CommonData.bin_to_ieee_754_float(<<20.79::float-32>>) == 20.79
    assert CommonData.bin_to_ieee_754_float(<<2.31::float-32>>) == 2.31
    assert CommonData.bin_to_ieee_754_float(<<2.30::float-32>>) == 2.3
    assert CommonData.bin_to_ieee_754_float(<<2.28::float-32>>) == 2.28
    assert CommonData.bin_to_ieee_754_float(<<2.19::float-32>>) == 2.19
  end

  test "random set of float data" do
    for _ <- 1..:rand.uniform(100) do
      num =
        :rand.uniform()
        |> Kernel.*(:rand.uniform(100))
        |> Float.ceil(3)
        |> Float.round(2)

      assert CommonData.bin_to_ieee_754_float(<<num::float-32>>) == num,
             "#{num} is not equal to itself after conversion"
    end
  end
end
