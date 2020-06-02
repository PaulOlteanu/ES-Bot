defmodule EmoteStore.Work do
  use Memento.Table,
    attributes: [:platform, :page],
    index: [],
    type: :set,
    autoincrement: false

  require Logger

  alias EmoteStore.Work

  def init_work(platform) do
    Memento.transaction!(fn ->
      %Work{platform: platform, page: 1}
      |> Memento.Query.write()
    end)
  end

  def increment_page(platform) do
    Memento.transaction!(fn ->
      Memento.Query.read(Work, platform)
      |> case do
        %Work{} = work ->
          Map.update!(work, :page, &(&1 + 1))
          |> Memento.Query.write()

        _ ->
          {:error, :not_found}
      end
    end)
  end

  def get_work(platform) do
    Memento.transaction!(fn ->
      Memento.Query.read(Work, platform)
    end)
    |> case do
      %Work{} = work -> work
      _ -> {:error, :not_found}
    end
  end
end
