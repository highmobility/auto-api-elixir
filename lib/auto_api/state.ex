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
defmodule AutoApi.State do
  @moduledoc """
  State behaviour
  """

  alias AutoApi.PropertyComponent

  @callback from_bin(binary) :: struct
  @callback to_bin(struct) :: binary
  @callback base() :: struct

  @type property(type) :: AutoApi.PropertyComponent.t(type) | nil
  @type multiple_property(type) :: list(AutoApi.PropertyComponent.t(type))

  defmacro __using__(spec_file: spec_file) do
    spec_path = Path.join(["specs", "capabilities", spec_file])
    raw_spec = Jason.decode!(File.read!(spec_path))
    struct_def = AutoApi.StateHelper.generate_struct(raw_spec)

    base =
      quote location: :keep do
        require Logger

        @behaviour AutoApi.State
        @dialyzer {:nowarn_function, to_properties: 4}

        @external_resource unquote(spec_path)

        @capability __MODULE__
                    |> Atom.to_string()
                    |> String.replace("State", "Capability")
                    |> String.to_atom()

        defstruct unquote(struct_def)

        @spec base() :: t
        def base, do: %__MODULE__{}

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
          {prop, value} = parse_bin_property(id, size, data)

          AutoApi.State.put(state, prop, value)
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
      end

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
      for prop <- raw_spec["properties"] do
        prop_name = String.to_atom(prop["name"])
        prop_id = prop["id"]

        quote location: :keep do
          defp parse_bin_property(unquote(prop_id), size, bin_data) do
            value = AutoApi.PropertyComponent.to_struct(bin_data, unquote(Macro.escape(prop)))

            {String.to_atom(unquote(prop["name"])), value}
          end

          defp parse_state_property(unquote(prop_name), data) when is_list(data) do
            data
            |> Enum.map(&parse_state_property(unquote(prop_name), &1))
            |> :binary.list_to_bin()
          end

          defp parse_state_property(unquote(prop_name), data) do
            data_bin = AutoApi.PropertyComponent.to_bin(data, unquote(Macro.escape(prop)))

            head = <<unquote(prop_id), byte_size(data_bin)::integer-16>>
            head <> data_bin
          end
        end
      end

    [timestamp, base, prop_funs]
  end

  @doc """
  Sets the value of a property.

  If the property is multiple the new value will be appended to the list of existing
  values.

  The value can be passed either as an `%AutoApi.PropertyComponent{}` struct, in which
  case it will be saved unchanged, or as a keyword list or map containing one of more of the
  components to be set. In this case a PropertyComponent structure will be created.

  Valid keys for the keyword list/map are:

  * `:data`
  * `:timestamp`
  * `:failure`
  * `:availability`

  # Examples

      iex> state = %AutoApi.DiagnosticsState{}
      iex> AutoApi.State.put(state, :odometer, data: {4325.4, :miles}, timestamp: ~U[2020-10-28 13:45:56Z])
      %AutoApi.DiagnosticsState{odometer: %AutoApi.PropertyComponent{data:  {4325.4, :miles}, timestamp: ~U[2020-10-28 13:45:56Z]}}

      iex> locks = [%AutoApi.PropertyComponent{data: %{location: :front_left, lock_state: :locked}}]
      iex> state = %AutoApi.DoorsState{locks: locks}
      iex> new_value = %AutoApi.PropertyComponent{data: %{location: :rear_right, lock_state: :unlocked}}
      iex> AutoApi.State.put(state, :locks, new_value)
      %AutoApi.DoorsState{locks: [
        %AutoApi.PropertyComponent{data: %{location: :front_left, lock_state: :locked}},
        %AutoApi.PropertyComponent{data: %{location: :rear_right, lock_state: :unlocked}}
      ]}

      iex> failure = %{reason: :rate_limit, description: "Try again tomorrow"}
      iex> availability = %{update_rate: :trip, rate_limit: {2, :times_per_day}, applies_per: :app}
      iex> state = %AutoApi.HoodState{}
      iex> AutoApi.State.put(state, :position, %{failure: failure, availability: availability})
      %AutoApi.HoodState{position: %AutoApi.PropertyComponent{
        failure: %{reason: :rate_limit, description: "Try again tomorrow"},
        availability: %{update_rate: :trip, rate_limit: {2, :times_per_day}, applies_per: :app}
      }}

  """
  @spec put(struct(), atom(), PropertyComponent.t() | keyword() | map()) :: struct()
  def put(state, property, property_component_or_params)

  def put(%state_module{} = state, property, %PropertyComponent{} = value) do
    if state_module.capability().multiple?(property) do
      Map.update(state, property, [value], &(&1 ++ [value]))
    else
      Map.put(state, property, value)
    end
  end

  def put(%{} = state, property, params) when is_list(params) or is_map(params) do
    value = struct(%AutoApi.PropertyComponent{}, params)

    put(state, property, value)
  end

  @doc """
  Clears a property from a state.

  If the property is multiple, all of its values will be removed.

  # Examples

      iex> locks = [%AutoApi.PropertyComponent{data: %{location: :front_left, lock_state: :locked}}]
      iex> state = %AutoApi.DoorsState{locks: locks}
      iex> AutoApi.State.clear(state, :locks)
      %AutoApi.DoorsState{locks: []}

      iex> state = %AutoApi.HoodState{position: %AutoApi.PropertyComponent{data: :intermediate}}
      iex> AutoApi.State.clear(state, :position)
      %AutoApi.HoodState{position: nil}
  """
  @spec clear(struct(), atom()) :: struct()
  def clear(%state_module{} = state, property) do
    if state_module.capability().multiple?(property) do
      Map.put(state, property, [])
    else
      Map.put(state, property, nil)
    end
  end
end
