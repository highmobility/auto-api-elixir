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
defmodule AutoApi.CommonData do
  @type location :: :front_left | :front_right | :rear_right | :rear_left

  def bin_location_to_atom(0x00), do: :front_left
  def bin_location_to_atom(0x01), do: :front_right
  def bin_location_to_atom(0x02), do: :rear_right
  def bin_location_to_atom(0x03), do: :rear_left

  def atom_location_to_bin(:front_left), do: 0x00
  def atom_location_to_bin(:front_right), do: 0x01
  def atom_location_to_bin(:rear_right), do: 0x02
  def atom_location_to_bin(:rear_left), do: 0x03

  @type position :: :closed | :open | :unavailable

  def atom_position_to_bin(:closed), do: 0x00
  def atom_position_to_bin(:open), do: 0x01
  def atom_position_to_bin(_), do: 0xFF

  def bin_position_to_atom(0x00), do: :closed
  def bin_position_to_atom(0x01), do: :open
  def bin_position_to_atom(_), do: :unavailable

  @type lock :: :unlocked | :locked

  def atom_lock_to_bin(:unlocked), do: 0x00
  def atom_lock_to_bin(:locked), do: 0x01

  def bin_lock_to_atom(0x00), do: :unlocked
  def bin_lock_to_atom(0x01), do: :locked

  @type electricity :: :on | :off

  def atom_electricity_to_bin(:off), do: 0x00
  def atom_electricity_to_bin(:on), do: 0x01

  def bin_electricity_to_atom(0x00), do: :off
  def bin_electricity_to_atom(0x01), do: :on

  def bin_to_ieee_754_float(<<f_value::float-32>>) do
    f_value
    |> Float.ceil(3)
    |> Float.round(2)
  end

  def convert_bin_to_integer(<<i_value::integer-8>>), do: i_value
  def convert_bin_to_integer(<<i_value::integer-16>>), do: i_value
  def convert_bin_to_integer(<<i_value::integer-24>>), do: i_value
  def convert_bin_to_integer(<<i_value::integer-32>>), do: i_value

  def convert_bin_to_integer(o) do
    throw({:can_not_parse_integer, o})
  end

  def convert_bin_to_float(<<f_value::float-32>>) do
    f_value
    |> Float.ceil(7)
    |> Float.round(6)
  end

  def convert_state_to_bin_integer(value, size) do
    size = size * 8
    <<value::integer-size(size)>>
  end

  def convert_state_to_bin_float(value, 4) do
    <<value::float-32>>
  end

  def convert_bin_to_double(<<f_value::float-64>>) do
    f_value
  end

  def convert_state_to_bin_double(value, 8) do
    <<value::float-64>>
  end
end
