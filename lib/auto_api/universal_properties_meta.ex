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
defmodule AutoApi.UniversalProperties.Meta do
  @moduledoc false

  # credo:disable-for-this-file Credo.Check.Refactor.CyclomaticComplexity

  @spec_file "specs/misc/universal_properties.json"
  @external_resource @spec_file

  defmacro __before_compile__(_env) do
    raw_spec = Jason.decode!(File.read!(@spec_file))

    properties = raw_spec["universal_properties"]

    base_functions =
      quote do
        @properties unquote(Macro.escape(properties))
                    |> Enum.map(fn prop ->
                      {prop["id"], String.to_atom(prop["name"])}
                    end)

        @doc """
        Returns all universal properties

        # Example

            iex> properties = AutoApi.UniversalProperties.all()
            iex> length(properties)
            5
            iex> List.last(properties)
            {0xA4, :brand}
        """
        @spec all() :: list({0..255, atom()})
        def all(), do: @properties

        @doc false
        @spec raw_spec() :: map()
        def raw_spec, do: unquote(Macro.escape(raw_spec))

        @doc false
        @spec property_spec(atom()) :: map()
        def property_spec(name)
      end

    property_functions =
      for prop <- properties do
        prop_name = String.to_atom(prop["name"])

        quote do
          def property_spec(unquote(prop_name)), do: unquote(Macro.escape(prop))
        end
      end

    [base_functions, property_functions]
  end
end
