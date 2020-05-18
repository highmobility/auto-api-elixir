defmodule AutoApi.CustomType.Implementation do
  @moduledoc false

  @spec_file "specs/misc/custom_types.json"
  @external_resource @spec_file

  defmacro __before_compile__(_env) do
    specs = Poison.decode!(File.read!(@spec_file))

    for type <- specs["types"] do
      name_atom = String.to_atom(type["name"])
      name_string = type["name"]

      quote do
        def spec(unquote(name_atom)), do: unquote(Macro.escape(type))
        def spec(unquote(name_string)), do: unquote(Macro.escape(type))
      end
    end
  end
end
