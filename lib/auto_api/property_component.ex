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
defmodule AutoApi.PropertyComponent do
  defstruct [:data, :timestamp, :failure]
  @prop_id_to_name %{0x01 => :data, 0x02 => :timestamp}
  @data_component_id 0x01
  @timestamp_component_id 0x02

  @type t :: %__MODULE__{data: any, timestamp: nil | DateTime.t(), failure: nil}
  @type data_types :: :integer
  @type size :: integer

  @doc """
  Converts PropertyComponent struct to binary"
  """
  @spec to_bin(t, data_types, size) :: binary
  def to_bin(%__MODULE__{data: nil, failure: failure}, _, _)
      when not is_nil(failure) do
    throw :handle_failure
  end

  def to_bin(%__MODULE__{} = prop, :double, size) do
    size_bit = size * 8

    <<@data_component_id, size::integer-16, prop.data::float-size(size_bit)>> <>
      timestamp_to_bin(prop.timestamp)
  end

  def to_bin(%__MODULE__{} = prop, :integer, size) do
    size_bit = size * 8

    <<@data_component_id, size::integer-16, prop.data::integer-size(size_bit)>> <>
      timestamp_to_bin(prop.timestamp)
  end

  @doc """
  Converts PropertyComponent binary to struct"
  """
  @spec to_struct(binary, data_types, size) :: binary
  def to_struct(binary, data_type, size) do
    prop_in_binary = split_binary_to_parts(binary, %__MODULE__{})
    data = to_value(prop_in_binary.data, data_type, size)
    timestamp = to_value(prop_in_binary.timestamp, :timestamp, 8)
    failure = failure_to_value(prop_in_binary.failure)
    %__MODULE__{data: data, timestamp: timestamp, failure: failure}
  end

  defp to_value(nil, _, _) do
    nil
  end

  defp to_value(binary_data, :double, _size) do
    AutoApi.CommonData.convert_bin_to_double(binary_data)
  end

  defp to_value(binary_data, :integer, _size) do
    AutoApi.CommonData.convert_bin_to_integer(binary_data)
  end

  defp to_value(binary_data, :timestamp, _size) do
    timestamp_in_milisec = AutoApi.CommonData.convert_bin_to_integer(binary_data)

    case DateTime.from_unix(timestamp_in_milisec, :millisecond) do
      {:ok, datetime} -> datetime
      _ -> nil
    end
  end

  defp failure_to_value(failure) when is_nil(failure), do: nil

  defp failure_to_value(failure) do
    throw :todo
  end

  defp split_binary_to_parts(
         <<prop_comp_id, prop_size::integer-16, prop_data::binary-size(prop_size), rest::binary>>,
         acc
       ) do
    acc = Map.put(acc, @prop_id_to_name[prop_comp_id], prop_data)
    split_binary_to_parts(rest, acc)
  end

  defp split_binary_to_parts(<<>>, acc), do: acc

  defp timestamp_to_bin(nil), do: <<>>

  defp timestamp_to_bin(timestamp) do
    milisec = DateTime.to_unix(timestamp, :millisecond)
    <<@timestamp_component_id, 8::integer-16, milisec::integer-64>>
  end
end
