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
  @callback name() :: atom
  @callback command_name(integer) :: atom
  @callback command_name(integer) :: atom
  @callback description :: String.t
  @callback capability_size :: integer
  @callback capabilities :: list(any)
  @callback to_map(binary) :: list(any)
  @callback to_map(binary, integer) :: map

  defmacro __using__(_opts) do
    quote do
      if @spec_file do
        spec = Poison.decode!(File.read!(@spec_file))
        @identifier <<spec["id_msb"], spec["id_lsb"]>>
        @name String.to_atom(spec["name"])
        @desc String.capitalize(spec["name"])
        message_types =
          spec["message_types"]
          |> Enum.map(fn msg_type -> {msg_type["id"], String.to_atom(msg_type["name"])} end)
          |> Enum.into(%{})
        @commands message_types
        properties =
          spec["properties"]
          |> Enum.map(fn prop -> {prop["id"], String.to_atom(prop["name"])} end)
        @properties properties
      end


      @command_ids Enum.into(Enum.map(@commands, fn {k,v} -> {v, k} end ), %{})

      def command, do: @command_module
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
      @spec description :: String.t
      def description, do: @desc

      @doc """
      Returns commands readable name.

      Available commands:

      ```
      #{inspect @commands, base: :hex}
      ```
      """
      @spec command_name(integer) :: __MODULE__.command_type | nil
      def command_name(id), do: Map.get(@commands, id)


      @doc """
      Return commands id based on atom
      """
      @spec command_id(__MODULE__.command_type) :: integer | nil
      def command_id(name), do: Map.get(@command_ids, name, -1)

      @doc """
      Deprecated. Use API level 5 and above.

      Returns capability size: #{@capability_size}
      """
      @deprecated "Use API level 5 and above"
      @spec capability_size :: integer
      def capability_size, do: @capability_size

      @doc """
      Deprecated. Use API level 5 and above.

      Retunrs capabilities under #{@desc}:

      ```
      #{inspect @sub_capabilities}
      ```
      """
      @deprecated "Use API level 5 and above"
      @spec capabilities :: list(map())
      def capabilities, do: @sub_capabilities


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

      Level 5:

          ie> HmAutoApi.DoorLocksCapability.to_map(<<0x00, 0x20, 0x01, 0x00, 0x02>>)
          [:lock_state, :get_lock_state, :lock_unlock_doors]


      Level 4:
          ie> HmAutoApi.DoorLocksCapability.to_map(<<0x1, 0x0>>)
          [%{bin: <<0x00>>, name: "Unavailable", atom: :unavailable, title: ""}]


      """
      @spec to_map(binary) :: list(command_type) :: list(map)
      def to_map(capability_bin) do
        id = @identifier
        case capability_bin do
          <<^id::binary-size(2), caps::binary>> ->
            caps
            |> :binary.bin_to_list
            |> Enum.map(fn action -> command_name(action) end)
          _ -> to_map_l4(capability_bin)
        end
      end


      @doc """
      Deprecated. Use API level 5 and above.
      """
      @deprecated "Use API level 5 and above"
      def to_map_l4(<<size, sub_caps::binary-size(size), rest::binary>>) do
        len = capability_size()
        sub_caps_list = :binary.bin_to_list(sub_caps)
        for index <- 0..len-1 do
          cap_bin = Enum.at(sub_caps_list, index)
          to_map(<<cap_bin>>, index)
        end
      end

      @doc """
      Deprecated. Use API level 5 and above.
      """
      @deprecated "Use API level 5 and above"
      def to_map(sub_cap_bin, index) when is_binary(sub_cap_bin) do
        sub_cap = Enum.at(@sub_capabilities, index)
        title = Map.get(sub_cap, :title, "")
        {cap_atom, cap_detail} = sub_cap.options
                                 |> Enum.filter(fn {_, opt} -> opt[:bin] == sub_cap_bin end)
                                 |> List.first
        cap_detail
        |> Map.put(:atom, cap_atom)
        |> Map.put(:title, title)
      end

      @doc """
      Returns binary value of capability based on list of available supported capabilities
      """
      @spec to_bin(list(command_type)) :: binary
      def to_bin(actions_list) do
        cap_iden = identifier()
        caps_binary =
          actions_list
          |> Enum.map(fn cap -> command_id(cap) end)
          |> :binary.list_to_bin
        cap_iden <> caps_binary
      end
    end
  end


  @capabilities %{
    <<0x00, 0x33>> => AutoApi.DiagnosticsCapability,
  }

  @doc """
    Returns full capabilities with all of them marked as disabled

      ie> <<cap_len, first_cap :: binary-size(3), _::binary>> = AutoApi.Capability.blank_capabilities
      ie> cap_len
      8
      ie> first_cap
      <<0, 0x20, 0>>
  """
  def blank_capabilities do
    caps_len = length(Map.keys(@capabilities))
    for {_, cap_module} <- @capabilities do
      iden = apply(cap_module, :identifier, [])
      cap_module
      |> apply(:capabilities, [])
      |> Enum.map(fn _ -> <<0>> end)
      |> Enum.reduce(iden, fn (i, x) -> x <> i end)
    end
    |> Enum.reduce(<<caps_len>>, fn (i, x) -> x <> i end)
  end

  def list_capabilities, do: @capabilities
end
