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
defmodule AutoApi.TypeSpec do
  @moduledoc false
  def for_state(properties_specs) do
    typespec =
      Enum.into(properties_specs, [], fn spec ->
        {
          name_atom(spec),
          spec |> typespec() |> wrap(spec["multiple"])
        }
      end)

    typespec = {:%, [], [{:__MODULE__, [], Elixir}, {:%{}, [], typespec}]}

    base_typespec =
      quote do
        @type t :: unquote(typespec)
      end

    local_typespecs =
      Enum.flat_map(properties_specs, fn
        %{"type" => "unit." <> _} -> []
        %{"type" => "types." <> _} -> []
        %{"type" => "events." <> _} -> []
        spec -> [for_custom_type(spec)]
      end)

    [local_typespecs, base_typespec]
  end

  def for_custom_type(%{"type" => "enum"} = spec) do
    name = name_atom(spec)
    typespec = enum(spec["enum_values"])

    quote do
      @type unquote({name, [], []}) :: unquote(typespec)
    end
  end

  def for_custom_type(%{"type" => "custom"} = spec) do
    name = name_atom(spec)
    typespec = custom(spec["items"])

    quote do
      @type unquote({name, [], []}) :: unquote(typespec)
    end
  end

  def for_custom_type(spec) do
    name = name_atom(spec)
    typespec = typespec(spec)

    quote do
      @type unquote({name, [], []}) :: unquote(typespec)
    end
  end

  defp custom(items) do
    typespec = Enum.reduce(items, [], &(&2 ++ [{atom(&1["name"]), typespec(&1)}]))
    {:%{}, [], typespec}
  end

  defp enum(items),
    do: items |> Enum.map(&atom(&1["name"])) |> enum_typespec()

  defp wrap(content, true),
    do: {{:., [], [AutoApi.State, :multiple_property]}, [], [content]}

  defp wrap(content, _),
    do: {{:., [], [AutoApi.State, :property]}, [], [content]}

  def typespec(%{"type" => "string"}),
    do: {{:., [], [String, :t]}, [], []}

  def typespec(%{"type" => "double"}),
    do: {:|, [], [{:float, [], []}, {:integer, [], []}]}

  def typespec(%{"type" => "uinteger"}),
    do: {:integer, [], []}

  def typespec(%{"type" => "integer"}),
    do: {:integer, [], []}

  def typespec(%{"type" => "bytes"}),
    do: {:binary, [], []}

  def typespec(%{"type" => "enum", "enum_values" => enums}),
    do: enum(enums)

  def typespec(%{"type" => "unit." <> unit}),
    do: {{:., [], [AutoApi.UnitType, atom(unit)]}, [], []}

  def typespec(%{"type" => "types." <> type}),
    do: {{:., [], [AutoApi.CustomType, atom(type)]}, [], []}

  def typespec(%{"type" => "timestamp"}),
    do: {{:., [], [DateTime, :t]}, [], []}

  def typespec(%{"type" => "events." <> type}),
    do: {{:., [], [AutoApi.Event, atom(type)]}, [], []}

  def enum_typespec([item]),
    do: item

  def enum_typespec([head | tail]),
    do: {:|, [], [head, enum_typespec(tail)]}

  defp name_atom(spec),
    do: atom(spec["name_sigular"] || spec["name"])

  defp atom(string),
    do: String.to_atom(string)
end
