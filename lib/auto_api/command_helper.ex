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
defmodule AutoApi.CommandHelper do
  @moduledoc false

  require Logger

  def inject_constants(data, constants, properties) do
    constants_data =
      constants
      |> Enum.map(fn {name, value} ->
        id = Keyword.get(properties, name)
        value_size = byte_size(value)

        <<id::8, value_size + 3::integer-16, 0x01, value_size::integer-16, value::binary>>
      end)
      |> :binary.list_to_bin()

    data <> constants_data
  end

  def reject_extra_properties(properties, allowed_properties) do
    Enum.reject(properties, fn {name, _} ->
      unless name in allowed_properties do
        Logger.warn(
          "Ignoring #{name} as it's not in the list of allowed properties for the setter: #{
            inspect allowed_properties
          }"
        )
      end
    end)
  end

  def raise_for_missing_properties(properties, mandatory_properties) do
    property_names = Enum.map(properties, &elem(&1, 0))
    missing_properties = mandatory_properties -- property_names

    case missing_properties do
      [] ->
        properties

      _ ->
        raise ArgumentError,
          message: "Missing properties for setter: #{inspect missing_properties}"
    end
  end

  def split_binary_properties(<<id, size::integer-16, data::binary-size(size), rest::binary>>) do
    [{id, data} | split_binary_properties(rest)]
  end

  def split_binary_properties(<<>>), do: []

  def get_state_properties(%state_module{} = state, properties) do
    stripped_state = Map.take(state, properties)

    struct(state_module, stripped_state)
  end

  def set_state_properties(state, properties) do
    # Multiple properties need to be replaced not appended
    state
    |> trim_multiple_properties(Keyword.keys(properties))
    |> update_properties(properties)
  end

  defp trim_multiple_properties(%state_module{} = state, properties) do
    properties
    |> Enum.filter(&state_module.capability().multiple?/1)
    |> Enum.reduce(state, &Map.put(&2, &1, []))
  end

  def convert_value_to_binary(%AutoApi.Property{} = value, spec) do
    AutoApi.Property.to_bin(value, spec)
  end

  def convert_value_to_binary(value, spec) do
    wrapped_value = %AutoApi.Property{data: value}
    convert_value_to_binary(wrapped_value, spec)
  end

  defp update_properties(state, properties) do
    Enum.reduce(properties, state, &update_property/2)
  end

  defp update_property({name, value}, %state_module{} = state) do
    Map.update!(state, name, fn existing_value ->
      if state_module.capability().multiple?(name) do
        existing_value ++ [value]
      else
        value
      end
    end)
  end
end
