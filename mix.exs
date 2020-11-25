defmodule ExMicrosoftbot.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ex_microsoftbot,
      version: "3.0.0",
      elixir: "~> 1.8",
      description: description(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      docs: [
        main: "readme",
        extras: ["README.md", "CHANGELOG.md"]
      ]
    ]
  end

  def description do
    "This library provides Elixir API wrapper for the Microsoft Bot Framework."
  end

  defp package do
    [
      licenses: ["MIT License"],
      maintainers: ["Zohaib Rauf", "Ben Hayden"],
      links: %{
        "GitHub" => "https://github.com/zabirauf/ex_microsoftbot",
        "Docs" => "https://hexdocs.pm/ex_microsoftbot/"
      }
    ]
  end

  def application do
    [
      mod: {ExMicrosoftBot, []},
      env: [
        endpoint: "https://api.botframework.com",
        openid_valid_keys_url:
          "https://login.botframework.com/v1/.well-known/openidconfiguration",
        issuer_claim: "https://api.botframework.com",
        audience_claim: Application.get_env(:ex_microsoftbot, :app_id),
        disable_token_validation: false
      ],
      registered: [ExMicrosoftBot.TokenManager, ExMicrosoftBot.SigningKeysManager],
      applications: applications(Mix.env())
    ]
  end

  defp applications(env) when env in [:dev, :prod] do
    [:logger, :jose, :httpotion, :tzdata, :timex, :poison]
  end

  defp applications(:test) do
    [:bypass | applications(:dev)]
  end

  defp deps do
    [
      {:httpotion, "~> 3.0.0"},
      {:poison, "~> 4.0"},
      {:jose, "~> 1.7"},
      {:timex, "~> 3.0"},
      {:tzdata, "~> 1.0"},
      {:inch_ex, "~> 2.0.0", only: :docs},
      {:dialyxir, "~> 0.3", only: [:dev]},
      {:ex_doc, "~> 0.19", only: [:dev]},
      {:bypass, "~> 1.0", only: :test}
    ]
  end
end
