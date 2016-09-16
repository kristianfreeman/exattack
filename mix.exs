defmodule ExAttack.Mixfile do
  use Mix.Project

  @url_github "https://github.com/imkmf/exattack"

  def project do
    [
      app: :exattack,
      description: "A Plug to protect against bad clients",
      version: "0.1.0",
      elixir: "~> 1.3",
      deps: deps(),
      package: package(),
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :cachex],
     mod: {ExAttack.Cache, []}]
  end

  defp package do
    [
      files: [
        "lib",
        "mix.exs",
        "LICENSE",
        "README.md"
      ],
      licenses: [ "apache2" ],
      links: %{
        "GitHub" => @url_github
      },
      maintainers: [ "Kristian Freeman" ],
      docs: [ extras: [ "README.md" ] ]
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:cachex, "~> 1.2.2"},
      {:ex_doc, "~> 0.13", optional: true, only: :dev}
    ]
  end
end
