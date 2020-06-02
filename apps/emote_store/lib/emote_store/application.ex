defmodule EmoteStore.Application do
  @moduledoc false

  require Logger

  use Application

  def start(_type, _args) do
    EmoteStore.setup_db()

    if EmoteStore.Work.get_work(:ffz) == {:error, :not_found}, do: EmoteStore.Work.init_work(:ffz)
    if EmoteStore.Work.get_work(:bttv) == {:error, :not_found}, do: EmoteStore.Work.init_work(:bttv)

    children = [
      {Registry, [keys: :unique, name: Application.fetch_env!(:emote_store, :worker_registry)]},
      {EmoteStore.Scraper.Supervisor, %{}}
    ]

    opts = [strategy: :one_for_one, name: EmoteStore.Supervisor]
    start_result = Supervisor.start_link(children, opts)

    if Application.fetch_env!(:emote_store, :scraping) do
      Logger.info("Starting with scraping enabled")
      EmoteStore.Scraper.Supervisor.start_child(:ffz)
      EmoteStore.Scraper.Supervisor.start_child(:bttv)
    else
      Logger.info("Starting with scraping disabled")
    end

    start_result
  end
end
