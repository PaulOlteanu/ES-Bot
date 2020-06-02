import Config

#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n"

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :emote_store,
  worker_registry: :scraper_worker_registry

config :ex_aws,
  region: "us-east-2",
  json_codec: Jason

config :mnesia,
  dir: '.mnesia/#{Mix.env()}/#{node()}'

import_config "#{Mix.env()}.exs"
import_config "#{Mix.env()}.secret.exs"
