defmodule AutoApiL11.Mixfile do
  use Mix.Project

  @version "0.2.0"

  def project do
    [
      app: :auto_api_l11,
      version: @version,
      elixir: "~> 1.6",
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

  defp deps do
    [
      {:propcheck, "~> 1.1", only: :test},
      {:jason, "~> 1.2"},
      {:ex_guard, "~> 1.3", only: :dev},
      {:ex_unit_notifier, "~> 0.1", only: :test},
      {:dialyxir, "~> 1.0.0-rc.3", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.18.1", only: :dev},
      {:earmark, "~> 1.2", only: :dev},
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false},
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
