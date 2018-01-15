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
defmodule AutoApi.State do
  @moduledoc """
  State behaviour

  It's important to be added after defstruct line:

      defmodule XxxState do
        defstruct x: nil
        use AutoApi.State
      end
  """
  @callback from_bin(binary) :: struct
  @callback to_bin(struct) :: binary
  @callback base() :: struct
  defmacro __using__(opts) do
    base =
      quote do
        alias AutoApi.CommonData
        @behaviour AutoApi.State
        @spec base :: t
        def base, do: %__MODULE__{}

        def parse_properties(<<id, size::integer-16, data::binary-size(size)>>, state) do
          do_parse_properties(id, data, state)
        end

        def parse_properties(
              <<id, size::integer-16, data::binary-size(size), rest::binary>>,
              state
            ) do
          state = do_parse_properties(id, data, state)
          parse_properties(rest, state)
        end

        def parse_properties(d, state) do
          state
        end

        def do_parse_properties(id, data, state) do
          {prop, value} = parse_property(id, data)

          if is_map(value) do
            current_value = Map.get(state, prop)
            %{state | prop => [value | current_value]}
          else
            %{state | prop => value}
          end
        end
      end

    spec = Poison.decode!(File.read!(opts[:spec_file]))

    prop_funs =
      for prop <- spec["properties"] do
        quote do
          case unquote(prop["type"]) do
            "enum" ->
              def parse_property(unquote(prop["id"]), <<value>>) do
                enum_values = unquote(Macro.escape(prop["values"]))

                enum_values
                |> Enum.filter(fn v -> v["id"] == value end)
                |> List.first()
                |> case do
                  nil ->
                    {:error, {:can_not_parse, value}}

                  matched_value ->
                    {String.to_atom(unquote(prop["name"])), matched_value["name"]}
                end
              end

            nil ->
              def parse_property(unquote(prop["id"]), data) do
                data_list = :binary.bin_to_list(data)

                {_, result} =
                  unquote(Macro.escape(prop["items"]))
                  |> Enum.reduce({0, []}, fn x, {counter, acc} ->
                    data_slice = :binary.list_to_bin(Enum.slice(data_list, counter, x["size"]))
                    # TODO: convert binary slices to their types
                    {counter + x["size"], [{String.to_atom(x["name"]), data_slice} | acc]}
                  end)

                {String.to_atom(unquote(prop["name"])), Enum.into(result, %{})}
              end

            _ ->
              def parse_property(unquote(prop["id"]), data) do
                value =
                  apply(AutoApi.CommonData, :"convert_bin_to_#{unquote(prop["type"])}", [data])

                {String.to_atom(unquote(prop["name"])), value}
              end
          end
        end
      end

    [base | prop_funs]
  end
end
