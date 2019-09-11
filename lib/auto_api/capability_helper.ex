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
defmodule AutoApi.CapabilityHelper do
  @moduledoc false

  require Logger

  def extract_setters_data(specs) do
    properties = specs["properties"]

    specs
    |> Map.get("setters", [])
    |> Enum.map(fn spec ->
      {
        String.to_atom(spec["name"]),
        {
          parse_properties(spec["mandatory"], properties),
          parse_properties(spec["optional"], properties)
        }
      }
    end)
  end

  defp parse_properties(nil, _), do: []

  defp parse_properties(property_ids, properties) do
    property_names =
      properties
      |> Enum.map(fn %{"id" => id, "name" => name} -> {id, name} end)
      |> Enum.into(%{})

    property_ids
    |> Enum.map(&Map.get(property_names, &1))
    |> Enum.map(&String.to_atom/1)
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
end
