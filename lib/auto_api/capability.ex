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
defmodule AutoApi.Capability do
  @moduledoc """
  Capability behaviour
  """

  @callback name() :: atom
  @callback command_name(integer) :: atom
  @callback command_name(integer) :: atom
  @callback commands :: list({integer, atom})
  @callback description :: String.t()
  @callback capability_size :: integer
  @callback capabilities :: list(any)
  @callback to_map(binary) :: list(any)
  @callback to_map(binary, integer) :: map

  defmacro __using__(_opts) do
    quote do
      @raw_spec Poison.decode!(File.read!(@spec_file))
      @external_resource @spec_file
      @identifier <<@raw_spec["identifier"]["msb"], @raw_spec["identifier"]["lsb"]>>
      @name String.to_atom(@raw_spec["name"])
      if @raw_spec["pretty_name"] do
        @desc @raw_spec["pretty_name"]
      else
        @desc @raw_spec["name"]
              |> String.split("_")
              |> Enum.map(&String.capitalize/1)
              |> Enum.join(" ")
      end

      message_types =
        @raw_spec["message_types"]
        |> Enum.map(fn msg_type -> {msg_type["id"], String.to_atom(msg_type["name"])} end)
        |> Enum.into(%{})

      @commands message_types
      properties =
        (@raw_spec["properties"] || [])
        |> Enum.map(fn prop -> {prop["id"], String.to_atom(prop["name"])} end)

      @properties properties

      @command_ids Enum.into(Enum.map(@commands, fn {k, v} -> {v, k} end), %{})

      @commands_list Enum.into(@commands, [])

      @doc false
      @spec raw_spec() :: map()
      def raw_spec, do: @raw_spec

      @doc """
      Returns map of commands id and thier name

        #{inspect @commands_list, base: :hex}
      """
      @spec commands :: list({integer, atom})
      def commands, do: @commands_list

      @doc """
      Returns the command module related to this capability
      """
      @spec command :: atom
      def command, do: @command_module

      @doc """
      Returns the command module related to this capability
      """
      # @spec state() :: atom
      def state, do: @state_module

      @doc """
      Retunrs capability's identifier: #{inspect @identifier, base: :hex}
      """
      @spec identifier :: binary
      def identifier, do: @identifier

      @doc """
      Returns capability's unique name: #{@name}
      """
      @spec name :: atom
      def name, do: @name

      @doc """
      Returns capability's description: #{@desc}
      """
      @spec description :: String.t()
      def description, do: @desc

      @doc """
      Returns commands readable name.

      Available commands:

      ```
      #{inspect @commands, base: :hex}
      ```
      """
      @spec command_name(integer) :: __MODULE__.command_type() | nil
      def command_name(id), do: Map.get(@commands, id)

      @doc """
      Return commands id based on atom
      """
      @spec command_id(__MODULE__.command_type()) :: integer | nil
      def command_id(name), do: Map.get(@command_ids, name, -1)

      @doc """
      Retunrs properties under #{@desc}:
      ```
      #{inspect @properties, base: :hex}
      ```
      """
      @spec properties :: list(tuple())
      def properties, do: @properties

      @doc """
      Returns list of supported sub capability based on binary value

      ## Example

          iex> AutoApi.DoorLocksCapability.to_map(<<0x00, 0x20, 0x01, 0x00, 0x12>>)
          [:lock_state, :get_lock_state, :lock_unlock_doors]

      """
      @spec to_map(binary) :: list(command_type)
      def to_map(capability_bin) do
        id = @identifier

        <<^id::binary-size(2), caps::binary>> = capability_bin

        caps
        |> :binary.bin_to_list()
        |> Enum.map(fn action -> command_name(action) end)
      end

      @doc """
      Returns binary value of capability based on list of available supported capabilities

      ## Example

          iex> AutoApi.DoorLocksCapability.to_bin([:get_lock_state, :lock_unlock_doors])
          <<0x00, 0x20, 0x00, 0x12>>

      """
      @spec to_bin(list(command_type)) :: binary
      def to_bin(actions_list) do
        cap_iden = identifier()

        caps_binary =
          actions_list
          |> Enum.map(fn cap -> command_id(cap) end)
          |> :binary.list_to_bin()

        cap_iden <> caps_binary
      end
    end
  end

  @doc """
    Returns full capabilities with all of them marked as disabled

      ie> <<cap_len, first_cap :: binary-size(3), _::binary>> = AutoApi.Capability.blank_capabilities
      ie> cap_len
      8
      ie> first_cap
      <<0, 0x20, 0>>
  """
  def blank_capabilities do
    caps_len = length(all())

    for cap_module <- all() do
      iden = apply(cap_module, :identifier, [])

      cap_module
      |> apply(:capabilities, [])
      |> Enum.map(fn _ -> <<0>> end)
      |> Enum.reduce(iden, fn i, x -> x <> i end)
    end
    |> Enum.reduce(<<caps_len>>, fn i, x -> x <> i end)
  end

  @doc """
  Returns a list of all capability modules.

  ## Examples

  iex> capabilities = AutoApi.Capability.all()
  iex> length(capabilities)
  51
  iex> List.first(capabilities)
  AutoApi.BrowserCapability
  """
  @spec all() :: list(module)
  defdelegate all(), to: AutoApi.CapabilityDelegate

  @doc """
  Returns a capability module by its binary id.

  Returns `nil` if there is no capability with the given id.

  ## Examples

  iex> AutoApi.Capability.get_by_id(<<0x00, 0x35>>)
  AutoApi.EngineCapability

  iex> AutoApi.Capability.get_by_id(<<0xDE, 0xAD>>)
  nil
  """
  @spec get_by_id(binary) :: module | nil
  defdelegate get_by_id(id), to: AutoApi.CapabilityDelegate

  @doc """
  Returns a capability module by its name.

  The name can be specified either as an atom or a string.

  Returns `nil` if there is no capability with the given name.

  ## Examples

  iex> AutoApi.Capability.get_by_name("door_locks")
  AutoApi.DoorLocksCapability

  iex> AutoApi.Capability.get_by_name(:wake_up)
  AutoApi.WakeUpCapability

  iex> AutoApi.Capability.get_by_name("Nobody")
  nil
  """
  @spec get_by_name(binary | atom) :: module | nil
  defdelegate get_by_name(name), to: AutoApi.CapabilityDelegate

  @doc """
  Returns a map with the capability identifiers as keys and the modules as values.

  ## Examples

  iex> capabilities = AutoApi.Capability.all()
  iex> list = Enum.into(capabilities, %{}, &{&1.identifier, &1})
  iex> AutoApi.Capability.list_capabilities == list
  true
  """
  @deprecated "Use all/0 and AutoApi.Capability.identifier/0 instead"
  defdelegate list_capabilities(), to: AutoApi.CapabilityDelegate
end
