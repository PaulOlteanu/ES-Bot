defmodule EmoteStore do
  def setup_db() do
    nodes = [node()]
    # Create the DB directory (if custom path given)
    if path = Application.get_env(:mnesia, :dir) do
      :ok = File.mkdir_p!(path)
    end

    # Create the Schema
    Memento.stop
    Memento.Schema.create(nodes)
    Memento.start

    # Create the DB with Disk Copies
    # TODO: Use Memento.Table.wait when it gets implemented
    Memento.Table.create(EmoteStore.Emote, disc_copies: nodes)
    :mnesia.wait_for_tables([EmoteStore.Emote], 5_000)
  end

  def get_emote(emote_name, index \\ 1) do
    emote = EmoteStore.Search.search(emote_name, index)

    if is_nil(emote) do
      nil
    else
      if saved_emote = EmoteStore.Emote.find_emote(emote) do
        saved_emote
      else
        EmoteStore.Emote.create_emote(emote)
      end
    end
  end
end
