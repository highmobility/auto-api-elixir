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
  @moduledoc false

  @type location :: :front_left | :front_right | :rear_right | :rear_left | :hatch | :all
  @type position :: :closed | :open
  @type lock :: :unlocked | :locked
  @type electricity :: :on | :off
  @type coordinates :: %{latitude: float, longitude: float}
  @type activity :: :inactive | :active
  @type activity_switched :: :deactivated | :activated
  @type axle :: :front_axle | :rear_axle
  @type weekday :: :monday | :tuesday | :wednesday | :thursday | :friday | :saturday | :sunday
  @type driving_mode :: :regular | :eco | :sport | :sport_plus
  @type network_security :: :none | :wep | :wpa | :wpa2_personal
  @type enabled_state :: :disabled | :enabled
  @type connection_state :: :disconnected | :connected

  def bin_to_ieee_754_float(<<f_value::float-32>>) do
    f_value
    |> Float.ceil(3)
    |> Float.round(2)
  end

  def convert_bin_to_integer(<<i_value::integer-8>>), do: i_value
  def convert_bin_to_integer(<<i_value::integer-16>>), do: i_value
  def convert_bin_to_integer(<<i_value::integer-24>>), do: i_value
  def convert_bin_to_integer(<<i_value::integer-32>>), do: i_value
  def convert_bin_to_integer(<<i_value::integer-64>>), do: i_value

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

  def convert_state_to_bin_datetime(datetime) do
    <<datetime.year - 2000, datetime.month, datetime.day, datetime.hour, datetime.minute,
      datetime.second, datetime.utc_offset::integer-16>>
  end

  def convert_bin_to_state_datetime(
        <<year, month, day, hour, minute, second, offset::signed-integer-16>>
      ) do
    %DateTime{
      year: year + 2000,
      month: month,
      day: day,
      hour: hour,
      minute: minute,
      second: second,
      utc_offset: offset,
      time_zone: get_timezone(offset),
      zone_abbr: get_zoneabbr(offset),
      std_offset: 0
    }
  end

  defp get_timezone(0), do: "Etc/UTC"
  defp get_timezone(_), do: ""
  defp get_zoneabbr(0), do: "UTC"
  defp get_zoneabbr(_), do: ""

  def convert_bin_to_state_failure_reason(0x00), do: :rate_limit
  def convert_bin_to_state_failure_reason(0x01), do: :execution_timeout
  def convert_bin_to_state_failure_reason(0x02), do: :format_error
  def convert_bin_to_state_failure_reason(0x03), do: :unauthorised
  def convert_bin_to_state_failure_reason(0x04), do: :unknown
  def convert_bin_to_state_failure_reason(0x05), do: :pending

  def convert_state_to_bin_failure_reason(:rate_limit), do: 0x00
  def convert_state_to_bin_failure_reason(:execution_timeout), do: 0x01
  def convert_state_to_bin_failure_reason(:format_error), do: 0x02
  def convert_state_to_bin_failure_reason(:unauthorised), do: 0x03
  def convert_state_to_bin_failure_reason(:unknown), do: 0x04
  def convert_state_to_bin_failure_reason(:pending), do: 0x05
end
