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

  alias AutoApi.CapabilityHelper

  defmacro __using__(spec_file: spec_file) do
    raw_spec = Poison.decode!(File.read!(spec_file))

    properties = raw_spec["properties"] || []

    base_functions =
      quote do
        @external_resource unquote(spec_file)
        @raw_spec unquote(Macro.escape(raw_spec))

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

        @properties unquote(Macro.escape(properties))
                    |> Enum.map(fn prop ->
                      {prop["id"], String.to_atom(prop["name"])}
                    end)

        @setters CapabilityHelper.extract_setters_data(@raw_spec)

        @state_properties CapabilityHelper.extract_state_properties(@raw_spec)

        @first_property unquote(Macro.escape(properties))
                        |> Enum.map(fn prop ->
                          {prop["id"], String.to_atom(prop["name"]), prop["multiple"] || false}
                        end)
                        |> List.first()

        @doc false
        @spec raw_spec() :: map()
        def raw_spec, do: @raw_spec

        @doc """
        Returns the command module related to this capability
        """
        @spec command :: atom
        def command, do: @command_module

        @doc """
        Returns the state module related to this capability
        """
        # @spec state() :: atom
        def state, do: @state_module

        @doc """
                Returns which properties are included in the State specification.

                ## Examples

        iex> AutoApi.SeatsCapability.state_properties()
        [:persons_detected, :seatbelts_state]

        iex> AutoApi.WakeUpCapability.state_properties()
        []
        """
        @spec state_properties() :: list(atom)
        def state_properties(), do: @state_properties

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
        Returns properties under #{@desc}:
        ```
        #{inspect @properties, base: :hex}
        ```
        """
        @spec properties :: list(tuple())
        def properties, do: @properties

        @doc """
        Returns the list of setters defined for the capability.

        The list is a `Keyword` with the setter name as a key and as value
        a tuple with three elements:

        1. _mandatory_ properties
        2. _optional_ properties
        3. _constants_

        ## Example

            iex> #{inspect __MODULE__}.setters()
            #{inspect @setters}

        """
        @spec setters() :: keyword({list(atom), list(atom), keyword(binary)})
        def setters(), do: @setters

        @doc """
        Returns the ID of a property given its name.

        ## Example

            iex> #{inspect __MODULE__}.property_id(#{inspect elem(@first_property, 1)})
            #{inspect elem(@first_property, 0)}

        """
        @spec property_id(atom()) :: integer()
        def property_id(name)

        @doc """
        Returns the name of a property given its ID.

        ## Example

            iex> #{inspect __MODULE__}.property_name(#{inspect elem(@first_property, 0)})
            #{inspect elem(@first_property, 1)}

        """
        @spec property_name(integer()) :: atom()
        def property_name(id)

        @doc false
        @spec property_spec(atom()) :: map()
        def property_spec(name)

        @doc """
        Returns whether the property is multiple, that is if it can contain multiple values.

        ## Example

            iex> #{inspect __MODULE__}.multiple?(#{inspect elem(@first_property, 1)})
            #{inspect elem(@first_property, 2)}
        """
        @spec multiple?(atom()) :: boolean()
        def multiple?(name)
      end

    property_functions =
      for prop <- properties do
        prop_id = prop["id"]
        prop_name = String.to_atom(prop["name"])
        multiple? = prop["multiple"] || false

        quote do
          def property_id(unquote(prop_name)), do: unquote(prop_id)
          def property_name(unquote(prop_id)), do: unquote(prop_name)
          def property_spec(unquote(prop_name)), do: unquote(Macro.escape(prop))
          def multiple?(unquote(prop_name)), do: unquote(multiple?)
        end
      end

    [base_functions, property_functions]
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
  AutoApi.IgnitionCapability

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

  iex> AutoApi.Capability.get_by_name("doors")
  AutoApi.DoorsCapability

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
