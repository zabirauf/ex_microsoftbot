defmodule ExMicrosoftbot.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_microsoftbot,
     version: "1.0.0",
     elixir: "~> 1.2",
     description: description,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package,
     deps: deps]
  end

  def description do
    "This library provides Elixir API wrapper for the Microsoft Bot Framework."
  end

  defp package do
    [
      licenses: ["MIT License"],
      maintainers: ["Zohaib Rauf"],
      links: %{
        "Github" => "https://github.com/zabirauf/ex_microsoftbot",
        "Docs" => "https://hexdocs.pm/ex_microsoftbot/"
      }
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpotion]]
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
      {:httpotion, "~> 2.2"},
      {:poison, "~> 2.1"},
      {:jose, "~> 1.7"},
      {:inch_ex, ">= 0.0.0", only: :docs},
      {:dialyxir, "~> 0.3", only: [:dev]},
      {:ex_doc, "~> 0.11.5", only: [:dev]}
    ]
  end
end
