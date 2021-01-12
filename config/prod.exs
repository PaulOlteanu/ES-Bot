import Config

config :logger, :console, level: :info

config :es_bot,
  register_globally: true,
  s3_bucket: "es-bot-prod"
