defmodule Bot.MixProject do
  use Mix.Project

  def project do
    [
      app: :bot,
      version: "1.0.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :httpoison],
      mod: {Bot.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:emote_store, in_umbrella: true},
      {:httpoison, "~> 1.6"},
      {:jason, "~> 1.2"},
      {:nostrum, "~> 0.4"}
    ]
  end
end
