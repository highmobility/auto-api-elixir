defmodule AutoApiL11.CustomType.Implementation do
  @moduledoc false

  @external_resource "specs/custom_types.json"

  defmacro __before_compile__(_env) do
    specs = Jason.decode!(File.read!("specs/custom_types.json"))

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
