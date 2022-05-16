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
defmodule AutoApi.Property do
  @moduledoc """
  Data wrapper for state properties.

  The struct contains three fields: `data`, `timestamp` and `failure`.

  The `data` field can be either a scalar or a map, and when set it contains
  the actual value of the state property.

  The `timestamp` field indicates when the data was last updated, and it is
  in `DateTime` format.

  The `failure` is set if there was an error that prevented retrieving the
  property data.

  The `availability` fields indicates how often the data is updated, and any
  limitation on how many times the property can receive updates in a specific
  time frame.
  """

  require Logger

  alias AutoApi.UnitType

  defstruct [:data, :timestamp, :failure, :availability]

  @prop_id_to_name %{0x01 => :data, 0x02 => :timestamp, 0x03 => :failure, 0x05 => :availability}
  @prop_name_to_id %{data: 0x01, timestamp: 0x02, failure: 0x03, availability: 0x05}

  @type reason ::
          :rate_limit
          | :execution_timeout
          | :format_error
          | :unauthorised
          | :unknown
          | :pending
          | :oem_error
          | :privacy_mode_active

  @type failure :: %{reason: reason(), description: String.t()}

  @type update_rate ::
          :trip_high
          | :trip
          | :trip_start_end
          | :trip_end
          | :unknown
          | :not_available
          | :on_change

  @type applies_per :: :app | :vehicle

  @type availability :: %{
          update_rate: update_rate(),
          rate_limit: UnitType.frequency(),
          applies_per: applies_per()
        }

  @type t(data) :: %__MODULE__{
          data: data,
          timestamp: nil | DateTime.t(),
          failure: nil | failure,
          availability: nil | availability
        }
  @type t() :: t(any())

  @type spec :: map() | list()

  @doc """
  Converts Property struct to binary format
  """
  @spec to_bin(__MODULE__.t(), spec()) :: binary()
  def to_bin(%__MODULE__{} = prop, spec) do
    try do
      wrap_with_size(prop, :data, &data_to_bin(&1, spec)) <>
        wrap_with_size(prop, :timestamp, &timestamp_to_bin/1) <>
        wrap_with_size(prop, :failure, &failure_to_bin/1) <>
        wrap_with_size(prop, :availability, &availability_to_bin/1)
    rescue
      error ->
        Logger.error([
          "Not able to serialize value for spec #{inspect(spec)} to binary ",
          inspect(error),
          " stacktrace: #{inspect Process.info(self(), :current_stacktrace)}"
        ])

        failure = %__MODULE__{
          failure: %{reason: :format_error, description: "not able to serialize the value"}
        }

        wrap_with_size(
          failure,
          :failure,
          &failure_to_bin/1
        )
    end
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

  defp data_to_bin(data, %{"type" => "string", "embedded" => true}) do
    <<byte_size(data)::integer-16, data::binary>>
  end

  defp data_to_bin(data, %{"type" => "string"}) do
    data
  end

  defp data_to_bin(data, %{"type" => "bytes", "embedded" => true}) do
    <<byte_size(data)::integer-16, data::binary>>
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

    <<data::integer-signed-size(size_bit)>>
  end

  defp data_to_bin(data, %{"type" => "uinteger", "size" => size}) do
    size_bit = size * 8

    <<data::integer-unsigned-size(size_bit)>>
  end

  defp data_to_bin(data, %{"type" => "timestamp"}) do
    timestamp_to_bin(data)
  end

  defp data_to_bin(data, %{"type" => "custom"} = specs) do
    bin_data = custom_type_to_bin(data, specs)

    if specs["embedded"] && is_nil(specs["size"]) do
      # Prepend with size only if embedded with no size, like string and bytes
      <<byte_size(bin_data)::integer-16, bin_data::binary>>
    else
      bin_data
    end
  end

  # Workaround while `capability_state` type is `bytes`
  defp data_to_bin(command, %{"type" => "types.capability_state"}) do
    AutoApi.Command.to_bin(command)
  end

  defp data_to_bin(data, %{"type" => "types." <> type} = spec) do
    type_spec = type |> AutoApi.CustomType.spec() |> Map.put("embedded", spec["embedded"])

    data_to_bin(data, type_spec)
  end

  defp data_to_bin(data, %{"type" => "events." <> type} = spec) do
    type_spec = type |> AutoApi.Event.spec() |> Map.put("embedded", spec["embedded"])

    data_to_bin(data, type_spec)
  end

  defp data_to_bin(%{value: value, unit: unit}, %{"type" => "unit." <> type}) do
    type_id = AutoApi.UnitType.id(type)
    unit_id = AutoApi.UnitType.unit_id(type, unit)

    unless unit_id,
      do: Logger.warn("type `#{type}` doesn't support unit `#{unit}`")

    <<type_id, unit_id, value::float-size(64)>>
  end

  defp custom_type_to_bin(data, specs) do
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

  defp timestamp_to_bin(nil), do: <<>>

  defp timestamp_to_bin(timestamp) do
    milisec = DateTime.to_unix(timestamp, :millisecond)
    <<milisec::integer-64>>
  end

  defp failure_to_bin(nil), do: <<>>

  defp failure_to_bin(%{reason: reason, description: description}) do
    reason_bin = AutoApi.FailureMessageState.failure_reason_name_to_bin(reason)
    description_size = byte_size(description)

    <<reason_bin, description_size::integer-16, description::binary>>
  end

  defp availability_to_bin(nil), do: <<>>

  defp availability_to_bin(availability) do
    # Availability type is "types.availability"
    data_to_bin(availability, %{"type" => "types.availability"})
  end

  @doc """
  Converts Property binary to struct
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
    availability = availability_to_value(prop_in_binary.availability)
    %__MODULE__{data: data, timestamp: timestamp, failure: failure, availability: availability}
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

  defp to_value(<<f_value::float-32>>, %{"type" => "float"}) do
    f_value
    |> Float.ceil(7)
    |> Float.round(6)
  end

  defp to_value(<<f_value::float-64>>, %{"type" => "double"}) do
    f_value
  end

  defp to_value(<<i_value::integer-signed-8>>, %{"type" => "integer"}), do: i_value
  defp to_value(<<i_value::integer-signed-16>>, %{"type" => "integer"}), do: i_value
  defp to_value(<<i_value::integer-signed-24>>, %{"type" => "integer"}), do: i_value
  defp to_value(<<i_value::integer-signed-32>>, %{"type" => "integer"}), do: i_value
  defp to_value(<<i_value::integer-signed-64>>, %{"type" => "integer"}), do: i_value
  defp to_value(o, %{"type" => "integer"}), do: throw({:can_not_parse_integer, o})

  defp to_value(<<i_value::integer-unsigned-8>>, %{"type" => "uinteger"}), do: i_value
  defp to_value(<<i_value::integer-unsigned-16>>, %{"type" => "uinteger"}), do: i_value
  defp to_value(<<i_value::integer-unsigned-24>>, %{"type" => "uinteger"}), do: i_value
  defp to_value(<<i_value::integer-unsigned-32>>, %{"type" => "uinteger"}), do: i_value
  defp to_value(<<i_value::integer-unsigned-64>>, %{"type" => "uinteger"}), do: i_value
  defp to_value(o, %{"type" => "uinteger"}), do: throw({:can_not_parse_uinteger, o})

  defp to_value(binary_data, %{"type" => "timestamp"}) do
    timestamp_in_milisec = to_value(binary_data, %{"type" => "uinteger"})

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
      counter = update_counter(counter, item_spec)

      if size - counter > byte_size(binary_data) do
        Logger.warn("not able to parse binary_data for #{inspect(specs)}")
      end

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
    AutoApi.Command.from_bin(binary_data)
  end

  defp to_value(binary_data, %{"type" => "types." <> type}) do
    type_spec = AutoApi.CustomType.spec(type)

    to_value(binary_data, type_spec)
  end

  defp to_value(binary_data, %{"type" => "events." <> type}) do
    type_spec = AutoApi.Event.spec(type)

    to_value(binary_data, type_spec)
  end

  defp to_value(<<id, unit_id, value::float-64>>, %{"type" => "unit." <> _type}) do
    unit = AutoApi.UnitType.unit_name(id, unit_id)

    %{value: value, unit: unit}
  end

  defp failure_to_value(nil), do: nil

  defp failure_to_value(failure) do
    <<reason, size::integer-16, description::binary-size(size)>> = failure

    %{
      reason: AutoApi.FailureMessageState.failure_reason_bin_to_name(reason),
      description: description
    }
  end

  defp availability_to_value(nil), do: nil

  defp availability_to_value(availability_bin) do
    # Availability type is "types.availability"
    to_value(availability_bin, %{"type" => "types.availability"})
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
    type
    |> AutoApi.CustomType.spec()
    |> Map.put("embedded", "true")
  end

  defp fetch_item_spec(%{"type" => "events." <> type}) do
    type
    |> AutoApi.Event.spec()
    |> Map.put("embedded", "true")
  end

  defp fetch_item_spec(spec) do
    Map.put(spec, "embedded", "true")
  end

  @sizeless_types ~w(custom string bytes)
  defp fetch_item_size(_binary_data, _counter, %{"size" => size}) do
    size
  end

  defp fetch_item_size(binary_data, counter, %{"type" => type}) when type in @sizeless_types do
    binary_data
    |> :binary.part(counter, 2)
    |> to_value(%{"type" => "uinteger"})
  end

  defp fetch_item_size(_, _, spec) do
    raise("couldn't find size for #{inspect(spec)}")
  end

  defp update_counter(counter, specs) do
    if specs["type"] in @sizeless_types && is_nil(specs["size"]) do
      counter + 2
    else
      counter
    end
  end
end
