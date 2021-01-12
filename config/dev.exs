import Config

config :logger, :console, level: :info

config :es_bot,
  register_globally: false,
  s3_bucket: "es-bot-dev"
