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

  alias AutoApi.Capability

  defmacro __using__(_opts) do
    quote do
      @behaviour AutoApi.Command

      @capability __MODULE__
                  |> Atom.to_string()
                  |> String.replace("Command", "Capability")
                  |> String.to_atom()

      @doc """
      Returns the capability module associated with the command
      """
      @spec capability() :: module()
      def capability(), do: @capability

      @doc """
      Converts the command to binary format.

      This function only supports the basic :get and :set commands.

      TODO: Implement conversion of the setters and getters from specs

      ## Examples

          iex> AutoApi.DiagnosticsCommand.to_bin(:get, [:mileage, :engine_rpm])
          <<0x00, 0x33, 0x00, 0x01, 0x04>>

          iex> prop = %AutoApi.PropertyComponent{data: 42, timestamp: ~U[2019-07-18 13:58:40.489250Z], failure: nil}
          iex> AutoApi.DiagnosticsCommand.to_bin(:set, speed: prop)
          <<0x00, 0x33, 0x01, 0x03, 1, 0, 2, 0, 42, 2, 0, 8, 0, 0, 1, 108, 5, 96, 184, 105>>
      """
      @spec to_bin(:get, list(:atom)) :: binary()
      def to_bin(:get, properties) when is_list(properties) do
        preamble = <<@capability.identifier() :: binary, 0x00>>
        state = @capability.state()

        Enum.reduce(properties, preamble, & &2 <> <<state.property_id(&1) :: 8>>)
      end

      @spec to_bin(:set, list({:atom, AutoApi.PropertyComponent.t()})) :: binary()
      def to_bin(:set, properties) when is_list(properties) do
        preamble = <<@capability.identifier() :: binary, 0x01>>
        state = @capability.state()

        Enum.into(properties, preamble, fn {property_name, value} ->
          spec = state.property_spec(property_name)
          value_bin = AutoApi.PropertyComponent.to_bin(value, spec)

          <<state.property_id(property_name) :: 8, value_bin :: binary>>
        end)
      end
    end
  end

  @type execute_return_atom :: :state | :state_changed
  @callback execute(struct, binary) :: {execute_return_atom, struct}
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
