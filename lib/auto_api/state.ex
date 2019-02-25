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

  alias AutoApi.CommonData
  require Logger

  defmacro __using__(opts) do
    base =
      quote do
        alias AutoApi.CommonData
        @behaviour AutoApi.State
        @dialyzer {:nowarn_function, to_properties: 4}
        @identifier __MODULE__
                    |> Atom.to_string()
                    |> String.replace("State", "Capability")
                    |> String.to_atom()
                    |> apply(:identifier, [])

        @spec base() :: t
        def base, do: %__MODULE__{}
        require Logger

        def identifier, do: @identifier

        def parse_bin_properties(<<id, size::integer-16, data::binary-size(size)>>, state) do
          do_parse_bin_properties(id, size, data, state)
        end

        def parse_bin_properties(
              <<id, size::integer-16, data::binary-size(size), rest::binary>>,
              state
            ) do
          state = do_parse_bin_properties(id, size, data, state)
          parse_bin_properties(rest, state)
        end

        def parse_bin_properties(d, state) do
          state
        end

        def do_parse_bin_properties(id, size, data, state) do
          {prop, multiple, value} = parse_bin_property(id, size, data)

          to_properties(state, prop, value, multiple)
        end

        defp to_properties(state, :timestamp, %DateTime{} = value, _) do
          %{state | :timestamp => value}
        end

        defp to_properties(state, :properties_failures, value, _) do
          Map.update!(state, :properties_failures, &Map.merge(&1, value))
        end

        defp to_properties(state, prop, value, true) do
          current_value = Map.get(state, prop)
          unless current_value, do: raise("`#{prop}` property is not defined as list")
          %{state | prop => current_value ++ [value]}
        end

        defp to_properties(state, prop, value, false) do
          %{state | prop => value}
        end

        def parse_state_properties(state) do
          state
          |> Map.from_struct()
          |> Enum.map(&do_parse_state_properties/1)
          |> :binary.list_to_bin()
        end

        defp do_parse_state_properties({name, value}) do
          parse_state_property(name, value)
        end

        # don't convert data to binary data if it's empty list
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
        def parse_state_property(:properties, _) do
          <<>>
        end

        # property_timestamps is especial item in state
        def parse_state_property(:property_timestamps, datetimes) do
          datetimes
          |> Enum.map(fn {prop_name, datetime} ->
            AutoApi.State.parse_state_property_timestamps_to_bin(__MODULE__, prop_name, datetime)
          end)
          |> Enum.join("")
        end

        def parse_state_property(:properties_failures, failures) do
          failures
          |> Enum.map(fn {prop_name, failure} ->
            AutoApi.State.parse_state_property_failures_to_bin(__MODULE__, prop_name, failure)
          end)
          |> Enum.join("")
        end

        @doc """
        Puts a value in the state.

        This function wraps the data in PropertyComponent
        """
        def put_property(state, property_name, data, timestamp \\ nil) do
          to_properties(
            state,
            property_name,
            %AutoApi.PropertyComponent{data: data, timestamp: timestamp},
            false
          )
        end

        @doc """
        Appends a value into a list
        This function wraps the data in PropertyComponent
        """
        def append_property(state, property_name, data, timestamp \\ nil) do
          to_properties(
            state,
            property_name,
            %AutoApi.PropertyComponent{data: data, timestamp: timestamp},
            true
          )
        end
      end

    spec = Poison.decode!(File.read!(opts[:spec_file]))

    timestamp =
      quote do
        def parse_bin_property(
              0xA2,
              _size,
              value
            ) do
          {:timestamp, false, DateTime.utc_now()}
        end
      end

    property_timestamp =
      quote do
        def parse_bin_property(
              0xA4,
              _size,
              value
            ) do
          {:property_timestamps, false,
           AutoApi.State.parse_bin_property_to_property_timestamp_helper(__MODULE__, value)}
        end
      end

    properties_failures =
      quote do
        def parse_bin_property(
              0xA5,
              _size,
              value
            ) do
          {:properties_failures, false,
           AutoApi.State.parse_bin_property_to_failure_helper(__MODULE__, value)}
        end
      end

    prop_funs =
      for prop <- spec["properties"] do
        prop_name = String.to_atom(prop["name"])
        prop_id = prop["id"]
        prop_type = prop["type"]
        prop_size = prop["size"]
        multiple = prop["multiple"] || false

        quote do
          if unquote(multiple) do
            def is_multiple?(unquote(prop_name)), do: true
          else
            def is_multiple?(unquote(prop_name)), do: false
          end

          def property_name(unquote(prop_id)), do: unquote(prop_name)
          def property_id(unquote(prop_name)), do: unquote(prop_id)

          case unquote(prop["type"]) do
            "enum" ->
              defp enum_name_to_id(unquote(prop_id)) do
                enum_values = unquote(Macro.escape(prop["values"]))

                enum_values
                |> Enum.map(fn enum_value ->
                  {String.to_atom(enum_value["name"]), enum_value["id"]}
                end)
                |> Map.new()
              end

              defp enum_id_to_name(unquote(prop_name)) do
                enum_values = unquote(Macro.escape(prop["values"]))

                enum_values
                |> Enum.map(fn enum_value ->
                  {enum_value["id"], String.to_atom(enum_value["name"])}
                end)
                |> Map.new()
              end

              # TODO: to remove!
              defp parse_enum(key, key_name, value)
                   when key in [unquote(prop_id), unquote(prop_name)] do
                enum_values = unquote(Macro.escape(prop["values"]))

                enum_values
                |> Enum.filter(fn v -> v[key_name] == value end)
                |> List.first()
              end

              def parse_bin_property(unquote(prop_id), _size, property_component_binary) do
                property_component =
                  AutoApi.PropertyComponent.to_struct(
                    property_component_binary,
                    unquote(Macro.escape(prop))
                  )

                case property_component.data do
                  nil ->
                    throw({:error, {:can_not_parse_enum, property_component_binary}})

                  matched_value ->
                    {unquote(prop_name), false, property_component}
                end
              end

              def parse_state_property(unquote(prop_name), property_component) do
                property_component_binary =
                  AutoApi.PropertyComponent.to_bin(
                    property_component,
                    unquote(Macro.escape(prop))
                  )

                head = <<unquote(prop_id), byte_size(property_component_binary)::integer-16>>
                head <> property_component_binary
              end

            nil ->
              # list type
              def parse_state_property(unquote(prop_name), []) do
                <<>>
              end

              if unquote(multiple) do
                def parse_state_property(unquote(prop_name), data) do
                  data
                  |> Enum.map(fn item ->
                    property_component_binary =
                      AutoApi.PropertyComponent.map_to_bin(
                        item,
                        unquote(Macro.escape(prop["items"]))
                      )

                    head = <<unquote(prop_id), byte_size(property_component_binary)::integer-16>>
                    head <> property_component_binary
                  end)
                  |> :binary.list_to_bin()
                end
              else
                def parse_state_property(unquote(prop_name), data) do
                  property_component_binary =
                    AutoApi.PropertyComponent.map_to_bin(
                      data,
                      unquote(Macro.escape(prop["items"]))
                    )

                  head = <<unquote(prop_id), byte_size(property_component_binary)::integer-16>>
                  head <> property_component_binary
                end
              end

              def parse_state_property_list(enum_values, unquote(prop_name), data) do
                AutoApi.State.parse_state_property_list_helper(
                  unquote(prop_id),
                  enum_values,
                  data
                )
              end

              def parse_bin_property(unquote(prop["id"]), _size, data) do
                data_component =
                  AutoApi.PropertyComponent.to_struct(data, unquote(Macro.escape(prop["items"])))

                {unquote(prop_name), unquote(multiple), data_component}
              end

            "string" ->
              def parse_bin_property(unquote(prop["id"]), _size, data) do
                data_component =
                  AutoApi.PropertyComponent.to_struct(data, unquote(Macro.escape(prop)))

                {String.to_atom(unquote(prop["name"])), unquote(multiple), data_component}
              end

              def parse_state_property(unquote(prop_name), data) when is_list(data) do
                data
                |> Enum.map(&parse_state_property(unquote(prop_name), &1))
                |> :binary.list_to_bin()
              end

              def parse_state_property(unquote(prop_name), data) do
                bin = AutoApi.PropertyComponent.to_bin(data, unquote(Macro.escape(prop)))
                head = <<unquote(prop_id), byte_size(bin)::integer-16>>
                head <> bin
              end

            "capability_state" ->
              def parse_bin_property(unquote(prop["id"]), _size, _data) do
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
                bin = AutoApi.PropertyComponent.to_bin(data, unquote(Macro.escape(prop)))
                head = <<unquote(prop_id), byte_size(bin)::integer-16>>
                head <> bin
              end

              def parse_bin_property(unquote(prop["id"]), size, bin_data) do
                value = AutoApi.PropertyComponent.to_struct(bin_data, unquote(Macro.escape(prop)))

                {String.to_atom(unquote(prop["name"])), unquote(multiple), value}
              end
          end
        end
      end

    [timestamp, property_timestamp, properties_failures] ++ [base] ++ [prop_funs]
  end

  def parse_state_property_list_helper(prop_id, enum_values, data) do
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

          "string" ->
            <<byte_size(value)::integer-16>> <> value

          type ->
            apply(AutoApi.CommonData, :"convert_state_to_bin_#{type}", [
              value,
              sub_prop["size"]
            ])
        end

      acc <> bin
    end

    binary_object =
      enum_values
      |> Enum.reject(&Map.get(&1, "size_reference", nil))
      |> Enum.map(fn sub_prop ->
        key = String.to_atom(sub_prop["name"])
        value = Map.get(data, key, 0)
        {sub_prop, value}
      end)
      |> Enum.reduce(
        <<>>,
        &reduce_func.(&1, &2)
      )

    <<prop_id, byte_size(binary_object)::integer-16>> <> binary_object
  end

  def parse_bin_property_to_list_helper(prop_name, items, data_list, multiple) do
    {_, result} =
      items
      |> Enum.reduce({0, []}, fn x, {counter, acc} ->
        size = x["size"] || Keyword.get(acc, String.to_atom("#{x["name"]}_size"))

        unless size, do: raise("couldn't find size for #{inspect(x)}")

        data_slice = :binary.list_to_bin(Enum.slice(data_list, counter, size))

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
                    "Can not parse #{inspect enum_value} for #{prop_name} in #{__MODULE__}"
                  )

                  0x00

                matched_value ->
                  String.to_atom(matched_value["name"])
              end

            "string" ->
              data_slice

            type ->
              apply(AutoApi.CommonData, :"convert_bin_to_#{type}", [data_slice])
          end

        # TODO: convert binary slices to their types
        {counter + size, [{String.to_atom(x["name"]), data_value} | acc]}
      end)

    {prop_name, multiple, Enum.into(result, %{})}
  end

  def parse_bin_property_to_date_helper(<<timestamp_binary::binary-size(8)>>) do
    CommonData.convert_bin_to_state_datetime(timestamp_binary)
  end

  def parse_bin_property_to_property_timestamp_helper(
        state_module,
        <<timestamp_binary::binary-size(8), prop_id, _::binary>>
      ) do
    %{
      state_module.property_name(prop_id) =>
        CommonData.convert_bin_to_state_datetime(timestamp_binary)
    }
  end

  def parse_bin_property_to_failure_helper(
        state_module,
        <<prop_id, reason, size, description::binary-size(size)>>
      ) do
    %{
      state_module.property_name(prop_id) =>
        {CommonData.convert_bin_to_state_failure_reason(reason), description}
    }
  end

  def parse_state_property_timestamps_to_bin(state_module, property_name, datetimes)
      when is_list(datetimes) do
    datetimes
    |> Enum.map(fn dt_value ->
      parse_state_property_timestamps_to_bin(state_module, property_name, dt_value)
    end)
    |> Enum.join("")
  end

  def parse_state_property_timestamps_to_bin(state_module, property_name, {datetime, value}) do
    case state_module.parse_state_property(property_name, [value]) do
      <<_id, data_size::integer-size(16), data::binary>> ->
        property_timestamp = CommonData.convert_state_to_bin_datetime(datetime)
        prop_size = data_size + byte_size(property_timestamp) + 1

        <<0xA4, prop_size::integer-16, property_timestamp::binary,
          state_module.property_id(property_name), data::binary>>

      _ ->
        Logger.error(
          "AutoApi.State can't parse the data #{inspect([state_module, property_name, value])}"
        )

        <<>>
    end
  end

  def parse_state_property_timestamps_to_bin(state_module, property_name, %DateTime{} = datetime) do
    <<0xA4, 9::integer-16, CommonData.convert_state_to_bin_datetime(datetime)::binary,
      state_module.property_id(property_name)>>
  end

  def put_with_timestamp(state, property_name, property_vaule, timestamp) do
    if state.__struct__.is_multiple?(property_name) do
      put_with_timestamp_multiple(state, property_name, property_vaule, timestamp)
    else
      put_with_timestamp_signle(state, property_name, property_vaule, timestamp)
    end
  end

  defp put_with_timestamp_multiple(state, property_name, property_vaule, timestamp) do
    current_property_timestamps = Map.get(state.property_timestamps, property_name, [])
    new_property_timestamps = [{timestamp, property_vaule} | current_property_timestamps]

    property_timestamps =
      Map.put(state.property_timestamps, property_name, new_property_timestamps)

    properties = Enum.uniq([:property_timestamps, property_name] ++ state.properties)

    existing_value = Map.get(state, property_name)

    state
    |> Map.put(property_name, [property_vaule | existing_value])
    |> Map.put(:property_timestamps, property_timestamps)
    |> Map.put(:properties, properties)
  end

  defp put_with_timestamp_signle(state, property_name, property_vaule, timestamp) do
    property_timestamps = Map.put(state.property_timestamps, property_name, timestamp)
    properties = Enum.uniq([:property_timestamps, property_name] ++ state.properties)

    state
    |> Map.put(property_name, property_vaule)
    |> Map.put(:property_timestamps, property_timestamps)
    |> Map.put(:properties, properties)
  end

  def parse_state_property_failures_to_bin(state_module, property_name, {reason, description}) do
    prop_id = apply(state_module, :property_id, [property_name])
    bin_reason = CommonData.convert_state_to_bin_failure_reason(reason)
    size = byte_size(description) + 3

    <<0xA5, size::16, prop_id, bin_reason, byte_size(description)::8, description::binary>>
  end

  def put_failure(state, property, reason, description) when byte_size(description) > 255 do
    put_failure(state, property, reason, binary_part(description, 0, 255))
  end

  def put_failure(state, property, reason, description) do
    properties = Enum.uniq([:properties_failures | state.properties])
    failure_keys = [Access.key(:properties_failures), Access.key(property)]

    state
    |> Map.put(:properties, properties)
    |> put_in(failure_keys, {reason, description})
  end
end
