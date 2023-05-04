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
defmodule AutoApi.UnitType.Meta do
  @moduledoc false

  # credo:disable-for-this-file Credo.Check.Refactor.CyclomaticComplexity

  @spec_file "specs/misc/unit_types.json"
  @external_resource @spec_file

  defmacro __before_compile__(_env) do
    specs = Jason.decode!(File.read!(@spec_file))

    type_names = for type <- specs["measurement_types"], do: String.to_atom(type["name"])

    base_functions =
      quote do
        @type id :: 1..255

        @doc """
        Returns all measurement types

        # Example

            iex> types = AutoApi.UnitType.all()
            iex> length(types)
            19
            iex> List.first(types)
            :acceleration
        """
        @spec all() :: list(atom())
        def all(), do: unquote(Macro.escape(type_names))

        @doc """
        Returns the ID of a measurement type given the name.

        The name can be expressed as a string or atom.

        # Examples

            iex> AutoApi.UnitType.id(:length)
            0x12
            iex> AutoApi.UnitType.id("power")
            0x14
        """
        @spec id(String.t() | atom()) :: id()
        def id(name)

        @doc """
        Returns the name of a measurement type given its ID

        # Example

            iex> AutoApi.UnitType.name(0x18)
            :torque
        """
        @spec name(id()) :: atom()
        def name(id)

        @doc """
        Returns all possible units for the given measurement type.

        The type can be specified either by ID or name (string or atom).

        # Examples

            iex> AutoApi.UnitType.units(:speed) |> List.first()
            :meters_per_second
            iex> AutoApi.UnitType.units("torque") |> List.first()
            :newton_meters
            iex> AutoApi.UnitType.units(0x11) |> List.first()
            :lux
        """
        @spec units(atom() | String.t() | id()) :: list(atom())
        def units(name_or_id)

        @doc """
        Returns the ID of an unit of measurement.

        The measurement name can be passed either as string or atom, but the unit name is only accepted in atom format.

        # Examples

            iex> AutoApi.UnitType.unit_id(:volume, :liters)
            0x02
            iex> AutoApi.UnitType.unit_id("power", :megawatts)
            0x03
            iex> AutoApi.UnitType.unit_id("power", :foobar)
            nil
        """
        @spec unit_id(String.t() | atom(), atom()) :: id() | nil
        def unit_id(type_name, unit_name)

        @doc """
        Returns the name of an unit of measurement.

        Both the type and unit must be specified by their IDs.

        # Example

            iex> AutoApi.UnitType.unit_name(0x16, 0x02)
            :miles_per_hour
        """
        @spec unit_name(id(), id()) :: atom()
        def unit_name(type_id, unit_id)
      end

    types_functions =
      for type <- specs["measurement_types"] do
        name_atom = String.to_atom(type["name"])
        name_string = type["name"]
        id = type["id"]

        units = for unit <- type["unit_types"], do: String.to_atom(unit["name"])

        unit_names =
          for unit <- type["unit_types"],
              into: %{},
              do: {unit["id"], String.to_atom(unit["name"])}

        unit_ids =
          for unit <- type["unit_types"],
              into: %{},
              do: {String.to_atom(unit["name"]), unit["id"]}

        units_typespec = AutoApi.TypeSpec.enum_typespec(units)
        value_typespec = AutoApi.TypeSpec.typespec(%{"type" => "double"})

        quote do
          @type unquote(name_atom)() :: %{
                  value: unquote(value_typespec),
                  unit: unquote(units_typespec)
                }

          @units unquote(Macro.escape(units))
          @unit_names unquote(Macro.escape(unit_names))
          @unit_ids unquote(Macro.escape(unit_ids))

          def id(unquote(name_atom)), do: unquote(id)
          def id(unquote(name_string)), do: unquote(id)

          def name(unquote(id)), do: unquote(name_atom)

          def units(unquote(id)), do: @units
          def units(unquote(name_atom)), do: @units
          def units(unquote(name_string)), do: @units

          def unit_id(unquote(name_atom), name), do: @unit_ids[name]
          def unit_id(unquote(name_string), name), do: @unit_ids[name]

          def unit_name(unquote(id), unit_id), do: @unit_names[unit_id]
        end
      end

    [base_functions, types_functions]
  end
end
