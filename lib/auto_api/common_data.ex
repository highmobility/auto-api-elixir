# AutoAPI
# The MIT License
#
# Copyright (c) 2018- High-Mobility GmbH (https://high-mobility.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
defmodule AutoApi.CommonData do
  @moduledoc false

  @type activity :: :inactive | :active
  @type activity_switched :: :deactivated | :activated
  @type connection_state :: :disconnected | :connected
  @type coordinates :: %{latitude: float, longitude: float}
  @type driving_mode :: :regular | :eco | :sport | :sport_plus | :ecoPlus | :comfort
  @type enabled_state :: :disabled | :enabled
  @type location :: :front_left | :front_right | :rear_right | :rear_left
  @type location_longitudinal :: :front | :rear
  @type lock :: :unlocked | :locked
  @type lock_safety :: :safe | :unsafe
  @type network_security :: :none | :wep | :wpa | :wpa2_personal
  @type on_off :: :on | :off
  @type position :: :closed | :open
  @type time :: %{hour: integer, minute: integer}

  def bin_to_ieee_754_float(<<f_value::float-32>>) do
    f_value
    |> Float.ceil(3)
    |> Float.round(2)
  end

  def convert_bin_to_integer(<<i_value::integer-signed-8>>), do: i_value
  def convert_bin_to_integer(<<i_value::integer-signed-16>>), do: i_value
  def convert_bin_to_integer(<<i_value::integer-signed-24>>), do: i_value
  def convert_bin_to_integer(<<i_value::integer-signed-32>>), do: i_value
  def convert_bin_to_integer(<<i_value::integer-signed-64>>), do: i_value

  def convert_bin_to_integer(o) do
    throw({:can_not_parse_integer, o})
  end

  def convert_bin_to_uinteger(<<i_value::integer-unsigned-8>>), do: i_value
  def convert_bin_to_uinteger(<<i_value::integer-unsigned-16>>), do: i_value
  def convert_bin_to_uinteger(<<i_value::integer-unsigned-24>>), do: i_value
  def convert_bin_to_uinteger(<<i_value::integer-unsigned-32>>), do: i_value
  def convert_bin_to_uinteger(<<i_value::integer-unsigned-64>>), do: i_value

  def convert_bin_to_uinteger(o) do
    throw({:can_not_parse_uinteger, o})
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
  def convert_bin_to_state_failure_reason(0x06), do: :oem_error
  def convert_bin_to_state_failure_reason(0x07), do: :privacy_mode_active

  def convert_state_to_bin_failure_reason(:rate_limit), do: 0x00
  def convert_state_to_bin_failure_reason(:execution_timeout), do: 0x01
  def convert_state_to_bin_failure_reason(:format_error), do: 0x02
  def convert_state_to_bin_failure_reason(:unauthorised), do: 0x03
  def convert_state_to_bin_failure_reason(:unknown), do: 0x04
  def convert_state_to_bin_failure_reason(:pending), do: 0x05
  def convert_state_to_bin_failure_reason(:oem_error), do: 0x06
  def convert_state_to_bin_failure_reason(:privacy_mode_active), do: 0x07
end
