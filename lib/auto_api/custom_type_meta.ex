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
defmodule AutoApi.CustomType.Meta do
  @moduledoc false
  defmacro __before_compile__(%{context_modules: [module]}) do
    {file, key} = Module.get_attribute(module, :spec_file)
    raw_spec = file |> File.read!() |> Jason.decode!()

    base_functions =
      for type <- raw_spec[key] do
        name_atom = String.to_atom(type["name"])
        name_string = type["name"]

        quote do
          def spec(unquote(name_atom)), do: unquote(Macro.escape(type))
          def spec(unquote(name_string)), do: unquote(Macro.escape(type))
        end
      end

    types_functions =
      for type <- raw_spec[key] do
        AutoApi.TypeSpec.for_custom_type(type)
      end

    [base_functions, types_functions]
  end
end
