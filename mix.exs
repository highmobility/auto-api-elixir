defmodule AutoApi.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :auto_api,
      version: @version,
      elixir: "~> 1.4",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [source_ref: "#{@version}", main: "AutoApi"],
      source_url: "https://github.com/highmobility/hm-auto-api-elixir",
      description: description(),
      package: package()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger, :public_key, :poison]]
  end

  defp deps do
    [
      {:poison, "~> 3.1", runtime: false},
      {:ex_guard, "~> 1.3", only: :dev},
      {:ex_unit_notifier, "~> 0.1", only: :test},
      {:dialyxir, "~> 0.5", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.18.1", only: :dev},
      {:earmark, "~> 1.2", only: :dev}
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
