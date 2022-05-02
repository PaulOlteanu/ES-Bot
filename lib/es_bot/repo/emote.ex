defmodule ESBot.Repo.Emote do
  use Memento.Table,
    attributes: [:id, :name, :s3_id, :provider, :provider_id],
    index: [:name],
    type: :ordered_set,
    autoincrement: true

  require Logger

  alias ESBot.Repo.Emote

  def create_emote(emote) do
    emote = Map.from_struct(emote)

    {provider_url, emote} = Map.pop(emote, :provider_url)
    {:ok, s3_id} = ESBot.S3.store_emote(provider_url)
    Memento.transaction!(fn ->
      struct(Emote, Map.put(emote, :s3_id, s3_id))
      |> Memento.Query.write()
    end)
  end

  def get_emote(emote_id) do
    Memento.transaction!(fn ->
      Memento.Query.read(Emote, emote_id)
    end)
    |> case do
      %Emote{} = emote -> emote
      _ -> {:error, :not_found}
    end
  end

  def delete_emote(emote_id) do
    Memento.transaction!(fn ->
      Memento.Query.delete(Emote, emote_id)
    end)
  end

  def find_emote(%{provider: provider, provider_id: provider_id} = _emote) do
    query = [
      {:==, :provider, provider},
      {:==, :provider_id, provider_id}
    ]

    Memento.transaction!(fn ->
      Memento.Query.select(Emote, query)
    end)
    |> List.first()
  end
end
