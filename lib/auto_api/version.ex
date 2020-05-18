defmodule AutoApi.Version do
  @moduledoc false

  @spec_file "specs/misc/version.json"
  @external_resource @spec_file

  defmacro __before_compile__(_env) do
    specs = Poison.decode!(File.read!(@spec_file))
    version = specs["version"]

    quote do
      @doc """
      Returns the current version of AutoApi

      ## Examples

          iex> AutoApi.version()
          12
      """
      def version(), do: unquote(Macro.escape(version))
    end
  end
end
