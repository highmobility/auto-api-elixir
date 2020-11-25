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
defmodule AutoApiL11.Command do
  @moduledoc """
  Command behavior for handling AutoApi commands
  """

  alias AutoApiL11.{Capability, CommandHelper}

  @type capability_name :: atom()
  @type action :: atom()
  @type data :: any()
  @type get_properties :: list(atom)
  @type set_properties :: keyword(AutoApiL11.PropertyComponent.t() | data())

  defmacro __using__(_opts) do
    capability =
      __CALLER__.module()
      |> Atom.to_string()
      |> String.replace(~r/Command$/, "Capability")
      |> String.to_atom()

    setter_names = Keyword.keys(capability.setters())

    property_ids = Enum.map(capability.properties(), fn {id, name} -> {name, id} end)

    base_functions =
      quote do
        @behaviour AutoApiL11.Command

        @type action :: atom()
        @type data :: any()
        @type get_properties :: list(atom)
        @type set_properties :: keyword(AutoApiL11.PropertyComponent.t() | data())

        @capability unquote(capability)
        @state @capability.state()
        @setter_names unquote(setter_names)
        @identifier @capability.identifier()
        @version 0x0B

        @doc """
        Returns the capability module associated with the command
        """
        @spec capability() :: module()
        def capability(), do: @capability

        @doc """
        Converts the command to binary format.

        See `AutoApiL11.PropertyComponent.to_bin/3` for an explanation of the arguments.

        ## Examples

            iex> AutoApiL11.DiagnosticsCommand.to_bin(:get, [:mileage, :engine_rpm])
            <<0x0B, 0x00, 0x33, 0x00, 0x01, 0x04>>

            iex> prop = %AutoApiL11.PropertyComponent{data: 42, timestamp: ~U[2019-07-18 13:58:40.489250Z], failure: nil}
            iex> AutoApiL11.DiagnosticsCommand.to_bin(:set, speed: prop)
            <<0x0B, 0x00, 0x33, 0x01, 0x03, 0, 16, 1, 0, 2, 0, 42, 2, 0, 8, 0, 0, 1, 108, 5, 96, 184, 105>>

            iex> AutoApiL11.ChargingCommand.to_bin(:set_charge_limit, charge_limit: 0.8)
            <<0x0B, 0, 35, 1, 8, 0, 11, 1, 0, 8, 63, 233, 153, 153, 153, 153, 153, 154>>

        """
        @spec to_bin(action, get_properties | set_properties) :: binary
        def to_bin(action, properties \\ [])

        def to_bin(:get, properties) when is_list(properties) do
          preamble = <<@version, @capability.identifier()::binary, 0x00>>

          Enum.reduce(properties, preamble, &(&2 <> <<@capability.property_id(&1)::8>>))
        end

        def to_bin(:set, properties) when is_list(properties) do
          preamble = <<@version, @capability.identifier()::binary, 0x01>>

          Enum.into(properties, preamble, fn {property_name, value} ->
            spec = @capability.property_spec(property_name)
            value_bin = CommandHelper.convert_value_to_binary(value, spec)
            size = byte_size(value_bin)

            <<@capability.property_id(property_name)::8, size::integer-16, value_bin::binary>>
          end)
        end

        @doc """
        Parses a command binary and returns

        Due to protocol restrictions, the `action` can only be `:get` or `:set`.

        In case of a `:get` action, the second item in the tuple will be a list
        of property names. As for protocol specifications, an empty list denotes
        a request of getting *all* state properties.

        If the action is `:set`, the second item will be a Keyword list with the
        property name as a key and a `AutoApiL11.PropertyComponent` as value.

        ## Examples

            iex> AutoApiL11.DiagnosticsCommand.from_bin(<<0x0B, 0x00, 0x33, 0x00, 0x01, 0x04>>)
            {:get, [:mileage, :engine_rpm]}

            iex> bin = <<0x0B, 0x00, 0x33, 0x01, 0x03, 0, 16, 1, 0, 2, 0, 42, 2, 0, 8, 0, 0, 1, 108, 5, 96, 184, 105>>
            iex> AutoApiL11.DiagnosticsCommand.from_bin(bin)
            {:set, [speed: %AutoApiL11.PropertyComponent{data: 42, timestamp: ~U[2019-07-18 13:58:40.489Z], failure: nil}]}
        """
        @spec from_bin(binary) ::
                {:get, list(atom)} | {:set, list({atom, AutoApiL11.PropertyComponent.t()})}
        def from_bin(<<@version, @identifier::binary, 0x00, properties::binary>>) do
          property_names =
            properties
            |> :binary.bin_to_list()
            |> Enum.map(&@capability.property_name/1)

          {:get, property_names}
        end

        def from_bin(<<@version, @identifier::binary, 0x01, property_data::binary>>) do
          properties =
            property_data
            |> CommandHelper.split_binary_properties()
            |> Enum.map(&parse_property/1)

          {:set, properties}
        end

        defp parse_property({id, data}) do
          name = @capability.property_name(id)
          spec = @capability.property_spec(name)
          value = AutoApiL11.PropertyComponent.to_struct(data, spec)

          {name, value}
        end

        @doc """
        Executes a binary command on a given state.

        ## Examples

            iex> state = %AutoApiL11.DiagnosticsState{
            ...>   mileage: %AutoApiL11.PropertyComponent{data: 42_567},
            ...>   speed: %AutoApiL11.PropertyComponent{data: 128}
            ...> }
            iex> cmd = AutoApiL11.DiagnosticsCommand.to_bin(:get, [:speed])
            iex> AutoApiL11.DiagnosticsCommand.execute(state, cmd)
            %AutoApiL11.DiagnosticsState{speed: %AutoApiL11.PropertyComponent{data: 128}, mileage: nil}

            iex> state = %AutoApiL11.DiagnosticsState{}
            iex> cmd = AutoApiL11.DiagnosticsCommand.to_bin(:set, speed: %AutoApiL11.PropertyComponent{data: 128})
            iex> AutoApiL11.DiagnosticsCommand.execute(state, cmd)
            %AutoApiL11.DiagnosticsState{speed: %AutoApiL11.PropertyComponent{data: 128}}
        """
        @spec execute(@state.t(), binary) :: @state.t()
        def execute(%@state{} = state, bin_cmd) do
          case from_bin(bin_cmd) do
            {:get, []} ->
              CommandHelper.get_state_properties(state, @capability.state_properties())

            {:get, properties} ->
              CommandHelper.get_state_properties(state, properties)

            {:set, properties} ->
              CommandHelper.set_state_properties(state, properties)
          end
        end

        @doc """
        Converts a #{inspect @state} struct to a binary state/set command.

        ## Example

            iex> state = %AutoApiL11.DiagnosticsState{
            ...>   speed: %AutoApiL11.PropertyComponent{data: 130}
            ...> }
            iex> AutoApiL11.DiagnosticsCommand.state(state)
            <<0x0B, 0, 51, 1, 3, 0, 5, 1, 0, 2, 0, 130>>
        """
        @spec state(@state.t()) :: binary
        def state(%@state{} = state) do
          <<@version>> <> @capability.identifier() <> <<0x01>> <> @state.to_bin(state)
        end
      end

    setter_functions =
      for setter <- setter_names do
        quote do
          def to_bin(unquote(setter), properties) when is_list(properties) do
            {mandatory, optional, constants} = Keyword.get(@capability.setters(), unquote(setter))

            included_properties =
              properties
              |> CommandHelper.reject_extra_properties(mandatory ++ optional)
              |> CommandHelper.raise_for_missing_properties(mandatory)

            :set
            |> to_bin(properties)
            |> CommandHelper.inject_constants(constants, unquote(property_ids))
          end
        end
      end

    [base_functions, setter_functions]
  end

  @callback execute(struct, binary) :: struct
  @callback state(struct) :: binary

  @doc """
  Extracts commands meta data  including the capability that
  the command is using and exact command that is issued

      iex> AutoApiL11.Command.meta_data(<<0x0B, 0x00, 0x33, 0x00>>)
      %{message_id: :diagnostics, message_type: :get, module: AutoApiL11.DiagnosticsCapability, version: 0x0B, properties: []}

      iex> AutoApiL11.Command.meta_data(<<0x0B, 0x00, 0x57, 0x00, 0x0B, 0x0C>>)
      %{message_id: :race, message_type: :get, module: AutoApiL11.RaceCapability, version: 0x0B, properties: [:gear_mode, :selected_gear]}

      iex> binary_command = <<0x0B, 0x00, 0x23, 0x1, 0x17, 0x00, 0x04, 0x01, 0x00, 0x01, 0x01>>
      iex> AutoApiL11.Command.meta_data(binary_command)
      %{message_id: :charging, message_type: :set, module: AutoApiL11.ChargingCapability, version: 0x0B, properties: [status: %AutoApiL11.PropertyComponent{data: :charging}]}
  """
  @spec meta_data(binary) :: map()
  def meta_data(<<0x0B, id::binary-size(2), _::binary>> = command_bin) do
    with capability_module when not is_nil(capability_module) <- Capability.get_by_id(id),
         capability_name <- capability_module.name(),
         {command_name, properties} <- capability_module.command.from_bin(command_bin) do
      %{
        message_id: capability_name,
        message_type: command_name,
        module: capability_module,
        version: 0x0B,
        properties: properties
      }
    else
      nil ->
        %{}
    end
  end

  @doc """
  Converts the command to the binary format.

  The command action can be `:get`, `:set` or one of the setters of the capability.

  In case the action is `:set` or one of the capability setter, the `properties`
  must be a keyword list with the property name as key and a
  `AutoApiL11.PropertyComponent` struct as value.

  It is also permitted, as a shorthand notation, to forego the `PropertyComponent`
  struct "wrapper" and pass directly the property value. In this case however
  it is not possible to specify the property timestamp nor a failure.

  ## Examples

      iex> AutoApiL11.Command.to_bin(:diagnostics, :get, [:mileage, :engine_rpm])
      <<0x0B, 0x00, 0x33, 0x00, 0x01, 0x04>>

      iex> prop = %AutoApiL11.PropertyComponent{data: 42, timestamp: ~U[2019-07-18 13:58:40.489250Z], failure: nil}
      iex> AutoApiL11.Command.to_bin(:diagnostics, :set, speed: prop)
      <<0x0B, 0x00, 0x33, 0x01, 0x03, 0, 16, 1, 0, 2, 0, 42, 2, 0, 8, 0, 0, 1, 108, 5, 96, 184, 105>>

      iex> AutoApiL11.Command.to_bin(:charging, :set_charge_limit, charge_limit: 0.8)
      <<0x0B, 0, 35, 1, 8, 0, 11, 1, 0, 8, 63, 233, 153, 153, 153, 153, 153, 154>>

  """
  @spec to_bin(capability_name, action, get_properties | set_properties) :: binary
  def to_bin(capability_name, action, properties) do
    capability = Capability.get_by_name(capability_name)

    capability.command.to_bin(action, properties)
  end
end
