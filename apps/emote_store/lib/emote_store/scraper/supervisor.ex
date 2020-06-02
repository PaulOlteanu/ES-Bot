defmodule EmoteStore.Scraper.Supervisor do
  use DynamicSupervisor

  require Logger

  def start_link(args) do
    DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_child(platform) do
    DynamicSupervisor.start_child(__MODULE__, {EmoteStore.Scraper.Worker, platform})
  end

  def stop_child(platform) do
    EmoteStore.Scraper.Worker.stop(platform)
  end
end
