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
defmodule AutoApi.PropertyComponent do
  @moduledoc """
  Data wrapper for state properties.

  The struct contains three fields: `data`, `timestamp` and `failure`.

  The `data` field can be either a scalar or a map, and when set it contains
  the actual value of the state property.

  The `timestamp` field indicates when the data was last updated, and it is
  in `DateTime` format.

  The `failure` is set if there was an error that prevented retrieving the
  property data.
  """

  require Logger

  defstruct [:data, :timestamp, :failure]

  @prop_id_to_name %{0x01 => :data, 0x02 => :timestamp, 0x03 => :failure}
  @prop_name_to_id %{:data => 0x01, :timestamp => 0x02, :failure => 0x03}

  @type reason ::
          :rate_limit
          | :execution_timeout
          | :format_error
          | :unauthorised
          | :unknown
          | :pending
          | :internal_oem_error
  @type failure :: %{reason: reason(), description: String.t()}
  @type t :: %__MODULE__{data: any, timestamp: nil | DateTime.t(), failure: nil | failure}
  @type spec :: map() | list()
  @type data_types :: :integer
  @type size :: integer

  @doc """
  Converts PropertyComponent struct to binary"
  """
  @spec to_bin(__MODULE__.t(), spec()) :: binary()
  def to_bin(%__MODULE__{} = prop, spec) do
    wrap_with_size(prop, :data, &data_to_bin(&1, spec)) <>
      wrap_with_size(prop, :timestamp, &timestamp_to_bin/1) <>
      wrap_with_size(prop, :failure, &failure_to_bin/1)
  end

  defp wrap_with_size(prop, field, conversion_fun) do
    case Map.get(prop, field) do
      nil ->
        <<>>

      value ->
        id = @prop_name_to_id[field]
        binary_value = conversion_fun.(value)
        size = byte_size(binary_value)
        <<id, size::integer-16, binary_value::binary>>
    end
  end

  defp data_to_bin(nil, _), do: <<>>

  defp data_to_bin(data, %{"embedded" => true, "type" => "string"}) do
    <<byte_size(data)::integer-16, data::binary>>
  end

  defp data_to_bin(data, %{"embedded" => true, "type" => "bytes"}) do
    <<byte_size(data)::integer-16, data::binary>>
  end

  defp data_to_bin(data, %{"type" => "string"}) do
    data
  end

  defp data_to_bin(data, %{"type" => "bytes"}) do
    data
  end

  defp data_to_bin(data, %{"type" => "enum"} = spec) do
    enum_id =
      spec["enum_values"]
      |> Enum.find(%{}, &(&1["name"] == Atom.to_string(data)))
      |> Map.get("id")

    unless enum_id, do: Logger.warn("Enum key `#{data}` doesn't exist in #{inspect spec}")

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

  defp data_to_bin(data, %{"type" => "uinteger", "size" => size}) do
    size_bit = size * 8

    <<data::integer-size(size_bit)>>
  end

  defp data_to_bin(data, %{"type" => "timestamp"}) do
    timestamp_to_bin(data)
  end

  defp data_to_bin(data, %{"type" => "custom"} = specs) do
    specs
    |> Map.get("items")
    |> Enum.map(&Map.put(&1, "embedded", true))
    |> Enum.map(fn %{"name" => name} = spec ->
      data
      |> Map.get(String.to_atom(name))
      |> data_to_bin(spec)
    end)
    |> :binary.list_to_bin()
  end

  # Workaround while `capability_state` type is `bytes`
  defp data_to_bin(%state_mod{} = state, %{"type" => "types.capability_state"}) do
    state_mod.identifier <> <<0x01>> <> state_mod.to_bin(state)
  end

  defp data_to_bin(data, %{"type" => "types." <> type}) do
    type_spec = AutoApi.CustomType.spec(type)

    data_to_bin(data, type_spec)
  end

  defp timestamp_to_bin(nil), do: <<>>

  defp timestamp_to_bin(timestamp) do
    milisec = DateTime.to_unix(timestamp, :millisecond)
    <<milisec::integer-64>>
  end

  defp failure_to_bin(nil), do: <<>>

  defp failure_to_bin(%{reason: reason, description: description}) do
    reason_bin = AutoApi.CommonData.convert_state_to_bin_failure_reason(reason)
    description_size = byte_size(description)

    <<reason_bin, description_size::integer-16, description::binary>>
  end

  @doc """
  Converts PropertyComponent binary to struct
  """
  @spec to_struct(binary(), spec()) :: __MODULE__.t()
  def to_struct(binary, specs) do
    prop_in_binary = split_binary_to_parts(binary, %__MODULE__{})
    data = to_value(prop_in_binary.data, specs)
    common_components_to_struct(prop_in_binary, data)
  end

  defp common_components_to_struct(prop_in_binary, data) do
    timestamp = to_value(prop_in_binary.timestamp, %{"type" => "timestamp"})
    failure = failure_to_value(prop_in_binary.failure)
    %__MODULE__{data: data, timestamp: timestamp, failure: failure}
  end

  defp to_value(nil, _) do
    nil
  end

  defp to_value(binary_data, %{"type" => "string"}) do
    binary_data
  end

  defp to_value(binary_data, %{"type" => "bytes"}) do
    binary_data
  end

  defp to_value(binary_data, %{"type" => "float"}) do
    AutoApi.CommonData.convert_bin_to_float(binary_data)
  end

  defp to_value(binary_data, %{"type" => "double"}) do
    AutoApi.CommonData.convert_bin_to_double(binary_data)
  end

  defp to_value(binary_data, %{"type" => "integer"}) do
    AutoApi.CommonData.convert_bin_to_integer(binary_data)
  end

  defp to_value(binary_data, %{"type" => "uinteger"}) do
    AutoApi.CommonData.convert_bin_to_integer(binary_data)
  end

  defp to_value(binary_data, %{"type" => "timestamp"}) do
    timestamp_in_milisec = AutoApi.CommonData.convert_bin_to_integer(binary_data)

    case DateTime.from_unix(timestamp_in_milisec, :millisecond) do
      {:ok, datetime} -> datetime
      _ -> nil
    end
  end

  defp to_value(binary_data, %{"type" => "enum", "size" => size} = spec) do
    size_bit = size * 8
    <<enum_id::integer-size(size_bit)>> = binary_data

    enum_name =
      spec["enum_values"]
      |> Enum.find(%{}, &(&1["id"] == enum_id))
      |> Map.get("name")

    if enum_name do
      String.to_atom(enum_name)
    else
      Logger.warn("enum with value `#{binary_data}` doesn't exist in #{inspect spec}")
      raise ArgumentError, message: "Invalid enum ID #{inspect <<enum_id>>}"
    end
  end

  defp to_value(binary_data, %{"type" => "custom"} = specs) do
    specs
    |> Map.get("items")
    |> Enum.reduce({0, []}, fn spec, {counter, acc} ->
      item_spec = fetch_item_spec(spec)
      size = fetch_item_size(binary_data, counter, item_spec)
      counter = update_counter(item_spec, counter)

      data_value =
        binary_data
        |> :binary.part(counter, size)
        |> to_value(item_spec)

      {counter + size, [{String.to_atom(spec["name"]), data_value} | acc]}
    end)
    |> elem(1)
    |> Enum.into(%{})
  end

  # Workaround while `capability_state` type is `bytes`
  defp to_value(binary_data, %{"type" => "types.capability_state"}) do
    <<cap_id::binary-size(2), 0x01, bin_state::binary>> = binary_data
    cap_mod = AutoApi.Capability.get_by_id(cap_id)

    cap_mod.state.from_bin(bin_state)
  end

  defp to_value(binary_data, %{"type" => "types." <> type}) do
    type_spec = AutoApi.CustomType.spec(type)

    to_value(binary_data, type_spec)
  end

  defp failure_to_value(nil), do: nil

  defp failure_to_value(failure) do
    <<reason, size::integer-16, description::binary-size(size)>> = failure

    %{
      reason: AutoApi.CommonData.convert_bin_to_state_failure_reason(reason),
      description: description
    }
  end

  defp split_binary_to_parts(
         <<prop_comp_id, prop_size::integer-16, prop_data::binary-size(prop_size), rest::binary>>,
         acc
       ) do
    acc = Map.put(acc, @prop_id_to_name[prop_comp_id], prop_data)
    split_binary_to_parts(rest, acc)
  end

  defp split_binary_to_parts(<<>>, acc), do: acc

  defp fetch_item_spec(%{"type" => "types." <> type}) do
    AutoApi.CustomType.spec(type)
  end

  defp fetch_item_spec(spec), do: spec

  defp fetch_item_size(_binary_data, _counter, %{"size" => size}) do
    size
  end

  defp fetch_item_size(binary_data, counter, %{"type" => "string"}) do
    # String type without size spec has a fixed size header of 2 bytes
    binary_data
    |> :binary.part(counter, 2)
    |> AutoApi.CommonData.convert_bin_to_integer()
  end

  defp fetch_item_size(binary_data, counter, %{"type" => "bytes"}) do
    # Bytes type without size spec has a fixed size header of 2 bytes
    binary_data
    |> :binary.part(counter, 2)
    |> AutoApi.CommonData.convert_bin_to_integer()
  end

  defp fetch_item_size(_, _, spec) do
    raise("couldn't find size for #{inspect(spec)}")
  end

  defp update_counter(%{"type" => "string"}, counter), do: counter + 2
  defp update_counter(%{"type" => "bytes"}, counter), do: counter + 2
  defp update_counter(_, counter), do: counter
end
