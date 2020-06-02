defmodule EmoteStore.Scraper.Worker do
  use GenServer

  alias EmoteStore.Work

  require Logger

  def child_spec(platform) do
    id = name = platform_to_name(platform)
    %{
      id: id,
      start: {__MODULE__, :start_link, [%{platform: platform, name: name}]},
      restart: :transient,
      shutdown: 40_000
    }
  end

  def start_link(%{platform: platform, name: name}) do
    GenServer.start_link(__MODULE__, %{platform: platform}, name: via_tuple(name))
  end

  def stop(platform) do
    GenServer.stop(via_tuple(platform_to_name(platform)))
  end

  @impl true
  def init(%{platform: platform}) do
    Logger.info("Starting up worker for #{platform}")
    %Work{page: page} = EmoteStore.Work.get_work(platform)
    Logger.info("Worker for #{platform} beginning on page #{page}")

    Process.send_after(self(), :scrape, 5 * 1000)
    {:ok, %{platform: platform, page: page}}
  end

  @impl true
  def handle_info(:scrape, %{page: page, platform: platform}) do
    Logger.info("Getting page #{page} on #{platform}")

    case EmoteStore.Platforms.get_platform(platform).get_page(page) do
      {:ok, emotes} ->
        Enum.map(emotes, fn %{name: name, url: url} ->
          EmoteStore.Emote.create_emote(name, url)
        end)

      {:error, reason} ->
        case reason do
          %HTTPoison.Error{id: id, reason: r} ->
            Logger.error("HTTPoison Error: Id: #{id}, Reason: #{r}")
          _ ->
            Logger.error("Error: #{reason}")
        end

      e ->
        Logger.error("UNKNOWN ERROR!: #{e}")
    end

    EmoteStore.Work.increment_page(platform)

    Logger.info("Next scrape for #{platform} will be at #{DateTime.add(DateTime.now!("America/Toronto"), 5 * 60, :second)}")
    Process.send_after(self(), :scrape, 5 * 60 * 1000)
    {:noreply, %{platform: platform, page: page + 1}}
  end

  @impl true
  def handle_info({:ssl_closed, _}, state) do
    {:noreply, state}
  end

  @impl true
  def terminate(reason, %{platform: platform}) do
    Logger.info("Exiting scraper for #{platform} with reason: #{inspect reason}")
  end

  defp platform_to_name(platform), do: String.to_atom("#{platform}_scraper")
  defp via_tuple(name), do: {:via, Registry, {Application.fetch_env!(:emote_store, :worker_registry), name}}
end
