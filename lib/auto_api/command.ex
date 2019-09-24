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
defmodule AutoApi.Command do
  @moduledoc """
  Command behavior for handling AutoApi commands
  """

  alias AutoApi.{Capability, CapabilityHelper}

  defmacro __using__(_opts) do
    capability =
      __CALLER__.module()
      |> Atom.to_string()
      |> String.replace("Command", "Capability")
      |> String.to_atom()

    setter_names = Keyword.keys(capability.setters())

    property_ids = Enum.map(capability.properties(), fn {id, name} -> {name, id} end)

    base_functions =
      quote do
        @behaviour AutoApi.Command

        @capability unquote(capability)
        @state @capability.state()
        @setter_names unquote(setter_names)
        @identifier @capability.identifier()

        @doc """
        Returns the capability module associated with the command
        """
        @spec capability() :: module()
        def capability(), do: @capability

        @doc """
        Converts the command to binary format.

        The command action can be `:get`, `:set` or one of the setters: `#{inspect @setter_names}`

        ## Examples

            iex> AutoApi.DiagnosticsCommand.to_bin(:get, [:mileage, :engine_rpm])
            <<0x00, 0x33, 0x00, 0x01, 0x04>>

            iex> prop = %AutoApi.PropertyComponent{data: 42, timestamp: ~U[2019-07-18 13:58:40.489250Z], failure: nil}
            iex> AutoApi.DiagnosticsCommand.to_bin(:set, speed: prop)
            <<0x00, 0x33, 0x01, 0x03, 0, 16, 1, 0, 2, 0, 42, 2, 0, 8, 0, 0, 1, 108, 5, 96, 184, 105>>

            iex> prop = %AutoApi.PropertyComponent{data: 0.8}
            iex> AutoApi.ChargingCommand.to_bin(:set_charge_limit, charge_limit: prop)
            <<0, 35, 1, 8, 0, 11, 1, 0, 8, 63, 233, 153, 153, 153, 153, 153, 154>>

        """
        @spec to_bin(atom, list(atom) | list({atom, AutoApi.PropertyComponent.t()})) ::
                binary() | no_return()
        def to_bin(action, properties \\ [])

        def to_bin(:get, properties) when is_list(properties) do
          preamble = <<@capability.identifier()::binary, 0x00>>

          Enum.reduce(properties, preamble, &(&2 <> <<@capability.property_id(&1)::8>>))
        end

        def to_bin(:set, properties) when is_list(properties) do
          preamble = <<@capability.identifier()::binary, 0x01>>

          Enum.into(properties, preamble, fn {property_name, value} ->
            spec = @capability.property_spec(property_name)
            value_bin = AutoApi.PropertyComponent.to_bin(value, spec)
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
        property name as a key and a `AutoApi.PropertyComponent` as value.

        ## Examples

            iex> AutoApi.DiagnosticsCommand.from_bin(<<0x00, 0x33, 0x00, 0x01, 0x04>>)
            {:get, [:mileage, :engine_rpm]}

            iex> bin = <<0x00, 0x33, 0x01, 0x03, 0, 16, 1, 0, 2, 0, 42, 2, 0, 8, 0, 0, 1, 108, 5, 96, 184, 105>>
            iex> AutoApi.DiagnosticsCommand.from_bin(bin)
            {:set, [speed: %AutoApi.PropertyComponent{data: 42, timestamp: ~U[2019-07-18 13:58:40.489Z], failure: nil}]}
        """
        @spec from_bin(binary) ::
                {:get, list(atom)} | {:set, list({atom, AutoApi.PropertyComponent.t()})}
        def from_bin(<<@identifier::binary, 0x00, properties::binary>>) do
          property_names =
            properties
            |> :binary.bin_to_list()
            |> Enum.map(&@capability.property_name/1)

          {:get, property_names}
        end

        def from_bin(<<@identifier::binary, 0x01, property_data::binary>>) do
          properties = split_binary_properties(property_data)

          {:set, properties}
        end

        defp split_binary_properties(
               <<id, size::integer-16, data::binary-size(size), rest::binary>>
             ) do
          [parse_property(id, data) | split_binary_properties(rest)]
        end

        defp split_binary_properties(<<>>), do: []

        defp parse_property(id, data) do
          name = @capability.property_name(id)
          spec = @capability.property_spec(name)
          value = AutoApi.PropertyComponent.to_struct(data, spec)

          {name, value}
        end

        @doc """
        Executes a binary command on a given state.

        ## Examples

            iex> state = %AutoApi.DiagnosticsState{
            ...>   mileage: %AutoApi.PropertyComponent{data: 42_567},
            ...>   speed: %AutoApi.PropertyComponent{data: 128}
            ...> }
            iex> cmd = AutoApi.DiagnosticsCommand.to_bin(:get, [:speed])
            iex> AutoApi.DiagnosticsCommand.execute(state, cmd)
            %AutoApi.DiagnosticsState{speed: %AutoApi.PropertyComponent{data: 128}, mileage: nil}

            iex> state = %AutoApi.DiagnosticsState{}
            iex> cmd = AutoApi.DiagnosticsCommand.to_bin(:set, speed: %AutoApi.PropertyComponent{data: 128})
            iex> AutoApi.DiagnosticsCommand.execute(state, cmd)
            %AutoApi.DiagnosticsState{speed: %AutoApi.PropertyComponent{data: 128}}
        """
        @spec execute(@state.t(), binary) :: @state.t()
        def execute(%@state{} = state, bin_cmd) do
          case from_bin(bin_cmd) do
            {:get, []} -> get_state_properties(state, @capability.state_properties())
            {:get, properties} -> get_state_properties(state, properties)
            {:set, properties} -> set_state_properties(state, properties)
          end
        end

        defp get_state_properties(%state_module{} = state, properties) do
          stripped_state = Map.take(state, properties)

          struct(state_module, stripped_state)
        end

        defp set_state_properties(state, properties) do
          # TODO: multiple properties must be "reset" first
          Enum.reduce(properties, state, &struct(&2, [&1]))
        end

        @doc """
        Converts a #{inspect @state} struct to a binary state/set command.

        ## Example

            iex> state = %AutoApi.DiagnosticsState{
            ...>   speed: %AutoApi.PropertyComponent{data: 130}
            ...> }
            iex> AutoApi.DiagnosticsCommand.state(state)
            <<0, 51, 1, 3, 0, 5, 1, 0, 2, 0, 130>>
        """
        @spec state(@state.t()) :: binary
        def state(%@state{} = state) do
          @capability.identifier() <> <<0x01>> <> @state.to_bin(state)
        end
      end

    setter_functions =
      for setter <- setter_names do
        quote do
          def to_bin(unquote(setter), properties) when is_list(properties) do
            {mandatory, optional, constants} = Keyword.get(@capability.setters(), unquote(setter))

            included_properties =
              properties
              |> CapabilityHelper.reject_extra_properties(mandatory ++ optional)
              |> CapabilityHelper.raise_for_missing_properties(mandatory)

            :set
            |> to_bin(properties)
            |> CapabilityHelper.inject_constants(constants, unquote(property_ids))
          end
        end
      end

    [base_functions, setter_functions]
  end

  @callback execute(struct, binary) :: struct
  @callback state(struct) :: binary

  @type capability_name ::
          :door_locks
          | :charging
          | :diagnostics
          | :engine
          | :maintenance
          | :rooftop
          | :trunk_access
          | :vehicle_location
          | :hood
          | :rooftop_control

  @doc """
  Extracts commands meta data  including the capability that
  the command is using and exact command that is issued

      iex> AutoApi.Command.meta_data(<<0, 0x33, 0x00>>)
      %{message_id: :diagnostics, message_type: :get, module: AutoApi.DiagnosticsCapability}

      iex> binary_command = <<0x00, 0x23, 0x1, 20, 0, 7, 1, 0, 4, 66, 41, 174, 20>>
      iex> %{module: cap} = AutoApi.Command.meta_data(binary_command)
      %{message_id: :charging, message_type: :set, module: AutoApi.ChargingCapability}
      iex> base_state = cap.state.base
      %AutoApi.ChargingState{}
      iex> AutoApi.Command.execute(base_state, cap.command, binary_command)
      {:state_changed, %AutoApi.ChargingState{battery_temperature:  %AutoApi.PropertyComponent{data: 42.419998, failure: nil, timestamp: nil}}}

      ie> binary_command = <<0x00, 0x20, 0x1, 0x01, 0x00, 0x00, 0x00>>
      ie> %{module: cap} = AutoApi.Command.meta_data(binary_command)
      ie> base_state = cap.state.base
      %AutoApi.DoorLocksState{}
      ie> AutoApi.Command.execute(base_state, cap.command, binary_command)
      {:state_changed, %AutoApi.DoorLocksState{}}
      ie> AutoApi.Command.to_bin(:door_locks, :get_lock_state, [])
      <<0x0, 0x20, 0x0>>
      ie> AutoApi.Command.to_bin(:door_locks, :lock_unlock_doors, [:lock])
      <<0x0, 0x20, 0x02, 0x01>>


  """
  @spec meta_data(binary) :: map()
  def meta_data(<<id::binary-size(2), type, _data::binary>>) do
    with capability_module when not is_nil(capability_module) <- Capability.get_by_id(id),
         capability_name <- apply(capability_module, :name, []),
         command_name <- command_name(type) do
      %{message_id: capability_name, message_type: command_name, module: capability_module}
    else
      nil ->
        %{}
    end
  end

  defp command_name(0x00), do: :get
  defp command_name(0x01), do: :set

  @spec execute(map, atom, binary) :: {:state | :state_changed, map}
  def execute(struct, command, binary_command) do
    <<_::binary-size(2), sub_command::binary>> = binary_command
    command.execute(struct, sub_command)
  end

  @doc """
  Converts the command to the binary format.

  This function only supports the basic actions `:get` and `:set`.

  """
  @spec to_bin(capability_name, atom, list(any())) :: binary
  def to_bin(capability_name, action) do
    to_bin(capability_name, action, [])
  end

  def to_bin(capability_name, action, args) do
    if capability = Capability.get_by_name(capability_name) do
      command_bin = capability.command.to_bin(action, args)
      <<capability.identifier::binary, command_bin::binary>>
    else
      <<>>
    end
  end
end
