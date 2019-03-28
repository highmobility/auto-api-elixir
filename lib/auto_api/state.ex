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

  require Logger

  defmacro __using__(opts) do
    base =
      quote do
        alias AutoApi.CommonData
        @behaviour AutoApi.State
        @dialyzer {:nowarn_function, to_properties: 4}

        @capability __MODULE__
                    |> Atom.to_string()
                    |> String.replace("State", "Capability")
                    |> String.to_atom()

        @spec base() :: t
        def base, do: %__MODULE__{}
        require Logger

        def capability, do: @capability

        def identifier, do: apply(@capability, :identifier, [])

        def name, do: apply(@capability, :name, [])

        defp parse_bin_properties(<<id, size::integer-16, data::binary-size(size)>>, state) do
          do_parse_bin_properties(id, size, data, state)
        end

        defp parse_bin_properties(
               <<id, size::integer-16, data::binary-size(size), rest::binary>>,
               state
             ) do
          state = do_parse_bin_properties(id, size, data, state)
          parse_bin_properties(rest, state)
        end

        defp parse_bin_properties(extra_data, state) do
          Logger.warn("Skipping malformed state data: #{inspect extra_data}")

          state
        end

        defp do_parse_bin_properties(id, size, data, state) do
          {prop, multiple, value} = parse_bin_property(id, size, data)

          to_properties(state, prop, value, multiple)
        end

        defp to_properties(state, :timestamp, %DateTime{} = value, _) do
          %{state | :timestamp => value}
        end

        defp to_properties(state, prop, value, true) do
          current_value = Map.get(state, prop)
          unless current_value, do: raise("`#{prop}` property is not defined as list")
          %{state | prop => current_value ++ [value]}
        end

        defp to_properties(state, prop, value, false) do
          %{state | prop => value}
        end

        defp parse_state_properties(state) do
          state
          |> Map.from_struct()
          |> Enum.map(&do_parse_state_properties/1)
          |> :binary.list_to_bin()
        end

        defp do_parse_state_properties({name, value}) do
          parse_state_property(name, value)
        end

        # don't convert data to binary data if it's empty list or nil
        defp parse_state_property(_, []) do
          <<>>
        end

        defp parse_state_property(_, [empty_map]) when empty_map == %{} do
          <<>>
        end

        defp parse_state_property(_, empty_map) when empty_map == %{} do
          <<>>
        end

        defp parse_state_property(_, nil) do
          <<>>
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

        @doc """
        Puts a failure property in the state.

        This function wraps the failure in PropertyComponent
        """
        @spec put_failure(__MODULE__.t(), atom(), atom(), String.t(), DateTime.t() | nil) ::
                __MODULE__.t()
        def put_failure(state, property_name, reason, description, timestamp \\ nil) do
          prop = %AutoApi.PropertyComponent{
            failure: %{reason: reason, description: description},
            timestamp: timestamp
          }

          %{state | property_name => prop}
        end
      end

    spec = Poison.decode!(File.read!(opts[:spec_file]))

    timestamp =
      quote do
        defp parse_bin_property(
               0xA2,
               _size,
               value
             ) do
          {:timestamp, false, DateTime.utc_now()}
        end
      end

    prop_funs =
      for prop <- spec["properties"] do
        prop_name = String.to_atom(prop["name"])
        prop_id = prop["id"]
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
              defp parse_bin_property(unquote(prop_id), _size, property_component_binary) do
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

              defp parse_state_property(unquote(prop_name), property_component) do
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
              defp parse_state_property(unquote(prop_name), []) do
                <<>>
              end

              if unquote(multiple) do
                defp parse_state_property(unquote(prop_name), data) do
                  data
                  |> Enum.map(fn item ->
                    property_component_binary =
                      AutoApi.PropertyComponent.to_bin(
                        item,
                        unquote(Macro.escape(prop["items"]))
                      )

                    head = <<unquote(prop_id), byte_size(property_component_binary)::integer-16>>
                    head <> property_component_binary
                  end)
                  |> :binary.list_to_bin()
                end
              else
                defp parse_state_property(unquote(prop_name), data) do
                  property_component_binary =
                    AutoApi.PropertyComponent.to_bin(
                      data,
                      unquote(Macro.escape(prop["items"]))
                    )

                  head = <<unquote(prop_id), byte_size(property_component_binary)::integer-16>>
                  head <> property_component_binary
                end
              end

              defp parse_bin_property(unquote(prop["id"]), _size, data) do
                data_component =
                  AutoApi.PropertyComponent.to_struct(data, unquote(Macro.escape(prop["items"])))

                {unquote(prop_name), unquote(multiple), data_component}
              end

            "string" ->
              defp parse_bin_property(unquote(prop["id"]), _size, data) do
                data_component =
                  AutoApi.PropertyComponent.to_struct(data, unquote(Macro.escape(prop)))

                {String.to_atom(unquote(prop["name"])), unquote(multiple), data_component}
              end

              defp parse_state_property(unquote(prop_name), data) when is_list(data) do
                data
                |> Enum.map(&parse_state_property(unquote(prop_name), &1))
                |> :binary.list_to_bin()
              end

              defp parse_state_property(unquote(prop_name), data) do
                bin = AutoApi.PropertyComponent.to_bin(data, unquote(Macro.escape(prop)))
                head = <<unquote(prop_id), byte_size(bin)::integer-16>>
                head <> bin
              end

            "capability_state" ->
              defp parse_bin_property(unquote(prop["id"]), _size, data) do
                data_component =
                  AutoApi.PropertyComponent.to_struct(data, unquote(Macro.escape(prop)))

                {String.to_atom(unquote(prop["name"])), unquote(multiple), data_component}
              end

              defp parse_state_property(unquote(prop_name), states) when is_list(states) do
                states
                |> Enum.map(&parse_state_property(unquote(prop_name), &1))
                |> :binary.list_to_bin()
              end

              defp parse_state_property(unquote(prop_name), state) do
                bin = AutoApi.PropertyComponent.to_bin(state, unquote(Macro.escape(prop)))
                head = <<unquote(prop_id), byte_size(bin)::integer-16>>
                head <> bin
              end

            _ ->
              # scalar types
              defp parse_state_property(unquote(prop_name), data) do
                bin = AutoApi.PropertyComponent.to_bin(data, unquote(Macro.escape(prop)))
                head = <<unquote(prop_id), byte_size(bin)::integer-16>>
                head <> bin
              end

              defp parse_bin_property(unquote(prop["id"]), size, bin_data) do
                value = AutoApi.PropertyComponent.to_struct(bin_data, unquote(Macro.escape(prop)))

                {String.to_atom(unquote(prop["name"])), unquote(multiple), value}
              end
          end
        end
      end

    [timestamp, base, prop_funs]
  end

  @doc """
  Update a property value in the given state.

  If a property supports multiple value, appends the value to the property list
  """
  @spec update_property(map, atom(), any, DateTime.t() | nil) :: map
  def update_property(%state_module{} = state, key, value, timestamp \\ nil) do
    if state_module.is_multiple?(key) do
      state_module.append_property(state, key, value, timestamp)
    else
      state_module.put_property(state, key, value, timestamp)
    end
  end

  @doc """
  Update a property failure in the given state.
  """
  @spec put_failure(struct, atom, atom, String.t(), DateTime.t() | nil) :: module
  def put_failure(%state_module{} = state, property, reason, description, timestamp \\ nil) do
    state_module.put_failure(state, property, reason, description, timestamp)
  end
end
