defmodule EmoteStore.Emote do
  use Memento.Table,
    attributes: [:id, :name, :s3_id, :default?],
    index: [:name],
    type: :ordered_set,
    autoincrement: true

  require Logger

  alias EmoteStore.Emote

  def create_emote(name, url) do
    {:ok, s3_id} = EmoteStore.S3.store_emote(url)
    default? = find_default_emote(name) == nil
    Memento.transaction!(fn ->
      %Emote{name: name, s3_id: s3_id, default?: default?}
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

  def find_emotes(emote_name) do
    Memento.transaction!(fn ->
      Memento.Query.select(Emote, {:==, :name, emote_name})
    end)
  end

  def find_default_emote(emote_name) do
    guards = [
      {:==, :name, emote_name},
      {:==, :default?, true}
    ]
    Memento.transaction!(fn ->
      Memento.Query.select(Emote, guards)
    end)
    |> List.first()
  end
end
