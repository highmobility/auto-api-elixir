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
  require Logger

  defstruct [:data, :timestamp, :failure]

  @prop_id_to_name %{0x01 => :data, 0x02 => :timestamp, 0x03 => :failure}
  @prop_name_to_id %{:data => 0x01, :timestamp => 0x02, :failure => 0x03}

  @type reason ::
          :rate_limit | :execution_timeout | :format_error | :unauthorised | :unknown | :pending
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

  defp data_to_bin(data, specs) when is_list(specs) do
    specs
    |> Enum.map(fn %{"name" => name} = spec ->
      data
      |> Map.get(String.to_atom(name))
      |> data_to_bin(spec)
    end)
    |> :binary.list_to_bin()
  end

  defp data_to_bin(data, %{"type" => "string"}) do
    data
  end

  defp data_to_bin(data, %{"type" => "enum"} = spec) do
    enum_id =
      spec["values"]
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

  defp data_to_bin(%state_mod{} = state, %{"type" => "capability_state"}) do
    state_mod.identifier <> <<0x01>> <> state_mod.to_bin(state)
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
  Converts PropertyComponent binary to struct"
  """
  @spec to_struct(binary(), spec()) :: __MODULE__.t()
  def to_struct(binary, specs) when is_list(specs) do
    prop_in_binary = split_binary_to_parts(binary, %__MODULE__{})

    data =
      unless is_nil(prop_in_binary.data) do
        specs
        |> Enum.reduce({0, []}, fn spec, {counter, acc} ->
          size = spec["size"] || Keyword.get(acc, String.to_atom("#{spec["name"]}_size"))
          unless size, do: raise("couldn't find size for #{inspect(spec)}")

          data_slice = :binary.part(prop_in_binary.data, counter, size)

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
      end

    common_components_to_struct(prop_in_binary, data)
  end

  def to_struct(binary, %{"type" => "string"}) do
    prop_in_binary = split_binary_to_parts(binary, %__MODULE__{})
    data = to_value(prop_in_binary.data, "string")
    common_components_to_struct(prop_in_binary, data)
  end

  def to_struct(binary, %{"type" => "enum"} = spec) do
    prop_in_binary = split_binary_to_parts(binary, %__MODULE__{})
    data = enum_to_value(prop_in_binary.data, spec)
    common_components_to_struct(prop_in_binary, data)
  end

  def to_struct(binary, %{"type" => data_type}) do
    prop_in_binary = split_binary_to_parts(binary, %__MODULE__{})
    data = to_value(prop_in_binary.data, data_type)
    common_components_to_struct(prop_in_binary, data)
  end

  defp common_components_to_struct(prop_in_binary, data) do
    timestamp = to_value(prop_in_binary.timestamp, "timestamp")
    failure = failure_to_value(prop_in_binary.failure)
    %__MODULE__{data: data, timestamp: timestamp, failure: failure}
  end

  defp enum_to_value(binary_data, %{"size" => size} = spec) do
    size_bit = size * 8
    <<enum_id::integer-size(size_bit)>> = binary_data

    enum_name =
      spec["values"]
      |> Enum.find(%{}, &(&1["id"] == enum_id))
      |> Map.get("name")

    if enum_name do
      String.to_atom(enum_name)
    else
      Logger.warn("enum with value `#{binary_data}` doesn't exist in #{inspect spec}")
      nil
    end
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

  defp to_value(binary_data, "capability_state") do
    <<cap_id::binary-size(2), 0x01, bin_state::binary>> = binary_data
    cap_mod = AutoApi.Capability.list_capabilities()[cap_id]

    cap_mod.state.from_bin(bin_state)
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
end
