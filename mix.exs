defmodule EsBot.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      releases: [
        prod: [
          version: "1.0.0",
          applications: [emote_store: :permanent, bot: :permanent],
          include_executables_for: [:unix]
        ]
      ],
      version: "1.0.0",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    []
  end
end
