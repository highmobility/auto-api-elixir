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
defmodule AutoApi.Mixfile do
  use Mix.Project

  @version "13.0.0"

  def project do
    [
      app: :auto_api,
      version: @version,
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [source_ref: "#{@version}", main: "AutoApi"],
      source_url: "https://github.com/highmobility/hm-auto-api-elixir",
      description: description(),
      package: package(),
      dialyzer: [plt_cor_path: "_build/#{Mix.env()}"]
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger, :public_key]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:propcheck, "~> 1.1", only: :test},
      {:jason, "~> 1.2"},
      {:ex_guard, "~> 1.3", only: :dev},
      {:ex_unit_notifier, "~> 1.0", only: :test},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.23", only: :dev},
      {:earmark, "~> 1.2", only: :dev},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:assertions, "~> 0.10", only: :test}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE", "specs"],
      maintainers: ["Milad Rastian"],
      licenses: ["GPL 3.0"],
      links: %{GitHub: "https://github.com/highmobility/hm-auto-api-elixir"}
    ]
  end

  defp description do
    """
    AutoApi is able to parse and execute Auto API binary data
    """
  end
end
