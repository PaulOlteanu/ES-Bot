defmodule EmoteStore.MixProject do
  use Mix.Project

  def project do
    [
      app: :emote_store,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {EmoteStore.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_aws, "~> 2.1"},
      {:ex_aws_s3, "~> 2.0"},
      {:ex_image_info, "~> 0.2.4"},
      {:httpoison, "~> 1.6"},
      {:jason, "~> 1.2"},
      {:memento, "~> 0.3.1"},
      {:sweet_xml, "~> 0.6"},
      {:tzdata, "~> 1.0"}
    ]
  end
end
