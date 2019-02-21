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

  def map_to_bin(%__MODULE__{} = prop, spec) do
    data_component_bin =
      spec
      |> Enum.map(fn item_spec ->
        key_name = String.to_atom(item_spec["name"])

        prop.data
        |> Map.get(key_name)
        |> data_to_bin(item_spec)
      end)
      |> :binary.list_to_bin()

    data_component_size = byte_size(data_component_bin)

    <<@data_component_id, data_component_size::integer-16>> <>
      data_component_bin <> timestamp_to_bin(prop.timestamp)
  end

  @doc """
  Converts PropertyComponent struct to binary"
  """
  def to_bin(%__MODULE__{} = prop, spec) do
    data_component_bin = data_to_bin(prop.data, spec)
    data_component_size = byte_size(data_component_bin)

    <<@data_component_id, data_component_size::integer-16>> <>
      data_component_bin <> timestamp_to_bin(prop.timestamp)
  end

  defp data_to_bin(data, %{"type" => "string"} = spec) do
    data
  end

  defp data_to_bin(data, %{"type" => "enum"} = spec) do
    enum_id =
      spec["values"]
      |> Enum.find(%{}, &(&1["name"] == Atom.to_string(data)))
      |> Map.get("id")

    <<enum_id>>
  end

  defp data_to_bin(data, %{"type" => "float", "size" => size}) do
    size_bit = size * 8

    <<data::float-size(size_bit)>>
  end

  defp data_to_bin(data, %{"type" => "double", "size" => size}) do
    size_bit = size * 8

    <<data::float-size(size_bit)>>
  end

  defp data_to_bin(data, %{"type" => "integer", "size" => size}) do
    size_bit = size * 8

    <<data::integer-size(size_bit)>>
  end

  @spec enum_to_bin(t, map) :: binary
  def enum_to_bin(%__MODULE__{} = prop, enum_name_to_id) do
    enum_id = enum_name_to_id[prop.data]

    <<@data_component_id, 1::integer-16, enum_id>> <> timestamp_to_bin(prop.timestamp)
  end

  @doc """
  Converts PropertyComponent binary to struct"
  """
  @spec to_struct(binary, map | list) :: binary
  def to_struct(binary, specs) when is_list(specs) do
    prop_in_binary = split_binary_to_parts(binary, %__MODULE__{})

    data = prop_in_binary.data

    data =
      specs
      |> Enum.reduce({0, []}, fn spec, {counter, acc} ->
        size = spec["size"] || Keyword.get(acc, String.to_atom("#{spec["name"]}_size"))
        unless size, do: raise("couldn't find size for #{inspect(spec)}")

        data_slice = :binary.part(data, counter, size)

        data_value =
          if spec["type"] == "enum" do
            enum_to_value(data_slice, spec)
          else
            to_value(data_slice, spec["type"])
          end

        {counter + size, [{String.to_atom(spec["name"]), data_value} | acc]}
      end)
      |> elem(1)
      |> Enum.into(%{})

    comon_components_to_struct(prop_in_binary, data)
  end

  def to_struct(binary, %{"type" => "string"} = spec) do
    prop_in_binary = split_binary_to_parts(binary, %__MODULE__{})
    data = to_value(prop_in_binary.data, "string")
    comon_components_to_struct(prop_in_binary, data)
  end

  def to_struct(binary, %{"type" => "enum", "size" => size} = spec) do
    prop_in_binary = split_binary_to_parts(binary, %__MODULE__{})
    data = enum_to_value(prop_in_binary.data, spec)
    comon_components_to_struct(prop_in_binary, data)
  end

  def to_struct(binary, %{"type" => data_type, "size" => size} = spec) do
    prop_in_binary = split_binary_to_parts(binary, %__MODULE__{})
    data = to_value(prop_in_binary.data, data_type)
    comon_components_to_struct(prop_in_binary, data)
  end

  defp comon_components_to_struct(prop_in_binary, data) do
    timestamp = to_value(prop_in_binary.timestamp, "timestamp")
    failure = failure_to_value(prop_in_binary.failure)
    %__MODULE__{data: data, timestamp: timestamp, failure: failure}
  end

  defp enum_to_value(binary_data, %{"size" => size} = spec) do
    size_bit = size * 8
    <<enum_id::integer-size(size_bit)>> = binary_data

    spec["values"]
    |> Enum.find(%{}, &(&1["id"] == enum_id))
    |> Map.get("name")
    |> String.to_atom()
  end

  defp to_value(nil, _) do
    nil
  end

  defp to_value(binary_data, "string") do
    binary_data
  end

  defp to_value(binary_data, "float") do
    AutoApi.CommonData.convert_bin_to_float(binary_data)
  end

  defp to_value(binary_data, "double") do
    AutoApi.CommonData.convert_bin_to_double(binary_data)
  end

  defp to_value(binary_data, "integer") do
    AutoApi.CommonData.convert_bin_to_integer(binary_data)
  end

  defp to_value(binary_data, "timestamp") do
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
