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
defmodule AutoApiL11.CapabilityHelper do
  @moduledoc false

  def extract_state_properties(specs) do
    properties = extract_property_data(specs)

    case Map.get(specs, "state") do
      nil ->
        []

      "all" ->
        Map.values(properties)

      prop_ids when is_list(prop_ids) ->
        Enum.map(prop_ids, &Map.get(properties, &1))
    end
  end

  def extract_setters_data(specs) do
    properties = extract_property_data(specs)

    specs
    |> Map.get("setters", [])
    |> Enum.map(fn spec ->
      {
        String.to_atom(spec["name"]),
        {
          parse_properties(spec["mandatory"], properties),
          parse_properties(spec["optional"], properties),
          parse_constants(spec["constants"], properties)
        }
      }
    end)
  end

  defp extract_property_data(%{"properties" => properties}) do
    properties
    |> Enum.map(fn %{"id" => id, "name" => name} -> {id, String.to_atom(name)} end)
    |> Enum.into(%{})
  end

  defp parse_properties(nil, _), do: []

  defp parse_properties(property_ids, properties) do
    Enum.map(property_ids, &Map.get(properties, &1))
  end

  defp parse_constants(nil, _), do: []

  defp parse_constants(constants, properties) do
    Enum.map(constants, fn %{"property_id" => id, "value" => value} ->
      {
        Map.get(properties, id),
        :binary.list_to_bin(value)
      }
    end)
  end

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
end
