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
        @identifier __MODULE__
                    |> Atom.to_string()
                    |> String.replace("State", "Capability")
                    |> String.to_atom()
                    |> apply(:identifier, [])
        def base, do: %__MODULE__{}
        require Logger

        def identifier, do: @identifier

        def parse_bin_properties(<<id, size::integer-16, data::binary-size(size)>>, state) do
          do_parse_bin_properties(id, data, state)
        end

        def parse_bin_properties(
              <<id, size::integer-16, data::binary-size(size), rest::binary>>,
              state
            ) do
          state = do_parse_bin_properties(id, data, state)
          parse_bin_properties(rest, state)
        end

        def parse_bin_properties(d, state) do
          state
        end

        def do_parse_bin_properties(id, data, state) do
          {prop, value} = parse_bin_property(id, data)

          to_properties(state, prop, value)
        end

        defp to_properties(state, prop, %DateTime{} = value) do
          %{state | prop => value}
        end

        defp to_properties(state, prop, value) when is_map(value) do
          current_value = Map.get(state, prop)
          %{state | prop => [value | current_value]}
        end

        defp to_properties(state, prop, value) do
          %{state | prop => value}
        end

        def parse_state_properties(state) do
          state
          |> Map.from_struct()
          |> Map.take(state.properties)
          |> Enum.map(&do_parse_state_properties/1)
          |> :binary.list_to_bin()
        end

        defp do_parse_state_properties({name, value}) do
          parse_state_property(name, value)
        end

        # don't convert data to binary data if it's nil
        def parse_state_property(_, []) do
          <<>>
        end

        def parse_state_property(_, [empty_map]) when empty_map == %{} do
          <<>>
        end

        def parse_state_property(_, empty_map) when empty_map == %{} do
          <<>>
        end

        def parse_state_property(_, nil) do
          <<>>
        end

        # properties is especial item in state
        def parse_state_property(:properties, []) do
          <<>>
        end
      end

    spec = Poison.decode!(File.read!(opts[:spec_file]))

    timestamp =
      quote do
        def parse_bin_property(
              0xA2,
              <<year, month, day, hour, minute, second, offset::signed-integer-16>>
            ) do
          date = %DateTime{
            year: year + 2000,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second,
            utc_offset: offset,
            time_zone: "",
            zone_abbr: "",
            std_offset: 0
          }

          {:timestamp, date}
        end
      end

    prop_funs =
      for prop <- spec["properties"] do
        prop_name = String.to_atom(prop["name"])
        prop_id = prop["id"]
        prop_type = prop["type"]
        prop_size = prop["size"]

        quote do
          case unquote(prop["type"]) do
            "enum" ->
              defp parse_enum(key, key_name, value)
                   when key in [unquote(prop_id), unquote(prop_name)] do
                enum_values = unquote(Macro.escape(prop["values"]))

                enum_values
                |> Enum.filter(fn v -> v[key_name] == value end)
                |> List.first()
              end

              def parse_bin_property(unquote(prop_id), <<value>>) do
                case parse_enum(unquote(prop_id), "id", value) do
                  nil ->
                    throw({:error, {:can_not_parse_enum, value}})

                  matched_value ->
                    {unquote(prop_name), String.to_atom(matched_value["name"])}
                end
              end

              def parse_state_property(unquote(prop_name), value) do
                case parse_enum(unquote(prop_name), "name", Atom.to_string(value)) do
                  nil ->
                    Logger.error(
                      "Can not parse #{inspect value} for #{unquote(prop_name)} in #{__MODULE__}"
                    )

                    <<>>

                  matched_value ->
                    head = <<unquote(prop_id), unquote(prop_size)::integer-16>>
                    head <> <<matched_value["id"]>>
                end
              end

            nil ->
              # list type
              def parse_state_property(unquote(prop_name), []) do
                <<>>
              end

              def parse_state_property(unquote(prop_name), data) do
                # TODO: should go through the items in order!
                enum_values = unquote(Macro.escape(prop["items"]))

                data
                |> Enum.map(fn item ->
                  parse_state_property_list(enum_values, unquote(prop_name), item)
                end)
                |> :binary.list_to_bin()
              end

              def parse_state_property_list(enum_values, unquote(prop_name), data) do
                find_type_fun = fn enum_values, key_name, value ->
                  enum_values
                  |> Enum.filter(fn v -> v[key_name] == value end)
                  |> List.first()
                end

                reduce_func = fn {sub_prop, value}, acc ->
                  bin =
                    case sub_prop["type"] do
                      "enum" ->
                        case find_type_fun.(sub_prop["values"], "name", Atom.to_string(value)) do
                          nil ->
                            throw({:error, {:can_not_parse_enum, value}})

                          matched_value ->
                            <<matched_value["id"]>>
                        end

                      type ->
                        apply(AutoApi.CommonData, :"convert_state_to_bin_#{type}", [
                          value,
                          sub_prop["size"]
                        ])
                    end

                  acc <> bin
                end

                enum_values
                |> Enum.map(fn sub_prop ->
                  key = String.to_atom(sub_prop["name"])
                  value = Map.get(data, key, 0)
                  {sub_prop, value}
                end)
                |> Enum.reduce(
                  <<unquote(prop_id), unquote(prop_size)::integer-16>>,
                  &reduce_func.(&1, &2)
                )
              end

              def parse_bin_property(unquote(prop["id"]), data) do
                data_list = :binary.bin_to_list(data)

                {_, result} =
                  unquote(Macro.escape(prop["items"]))
                  |> Enum.reduce({0, []}, fn x, {counter, acc} ->
                    data_slice = :binary.list_to_bin(Enum.slice(data_list, counter, x["size"]))

                    data_value =
                      case x["type"] do
                        "enum" ->
                          <<enum_value>> = data_slice

                          x["values"]
                          |> Enum.filter(&(&1["id"] == enum_value))
                          |> List.first()
                          |> case do
                            nil ->
                              Logger.error(
                                "Can not parse #{inspect enum_value} for #{unquote(prop_name)} in #{
                                  __MODULE__
                                }"
                              )

                              0x00

                            matched_value ->
                              String.to_atom(matched_value["name"])
                          end

                        type ->
                          apply(AutoApi.CommonData, :"convert_bin_to_#{type}", [data_slice])
                      end

                    # TODO: convert binary slices to their types
                    {counter + x["size"], [{String.to_atom(x["name"]), data_value} | acc]}
                  end)

                {unquote(prop_name), Enum.into(result, %{})}
              end

            "string" ->
              def parse_bin_property(unquote(prop["id"]), data) do
                value = data

                {String.to_atom(unquote(prop["name"])), value}
              end

              def parse_state_property(unquote(prop_name), data) do
                head = <<unquote(prop_id), byte_size(data)::integer-16>>
                head <> data
              end

            "capability_state" ->
              def parse_bin_property(unquote(prop["id"]), _data) do
                throw :not_implement
              end

              def parse_state_property(unquote(prop_name), states) do
                states
                |> Enum.map(fn state ->
                  mod = state.__struct__

                  body = mod.identifier <> <<1>> <> mod.to_bin(state)

                  <<unquote(prop_id), byte_size(body)::integer-16>> <> body
                end)
              end

            _ ->
              # scalar types
              def parse_state_property(unquote(prop_name), data) do
                bin =
                  apply(AutoApi.CommonData, :"convert_state_to_bin_#{unquote(prop_type)}", [
                    data,
                    unquote(prop_size)
                  ])

                head = <<unquote(prop_id), unquote(prop_size)::integer-16>>
                head <> bin
              end

              def parse_bin_property(unquote(prop["id"]), data) do
                value =
                  apply(AutoApi.CommonData, :"convert_bin_to_#{unquote(prop["type"])}", [data])

                {String.to_atom(unquote(prop["name"])), value}
              end
          end
        end
      end

    # [timestamp | [base | prop_funs]]
    [timestamp] ++ [base] ++ [prop_funs]
  end
end
