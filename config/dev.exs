import Config

config :logger, :console, level: :info

config :emote_store,
  s3_bucket: "emote-store-dev"
