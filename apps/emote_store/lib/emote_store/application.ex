defmodule EmoteStore.Application do
  @moduledoc false

  require Logger

  use Application

  def start(_type, _args) do
    EmoteStore.setup_db()

    children = [
      {Registry, [keys: :unique, name: Application.fetch_env!(:emote_store, :worker_registry)]}
    ]

    opts = [strategy: :one_for_one, name: EmoteStore.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
