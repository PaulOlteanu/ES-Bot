defmodule ESBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :es_bot,
      version: "1.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        prod: [
          version: "1.1.0",
          include_executables_for: [:unix]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ESBot.Application, []}
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
      {:nostrum, "~> 0.4"},
      {:sweet_xml, "~> 0.6"},
      {:tzdata, "~> 1.0"}
    ]
  end
end
