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
    # TODO:
    # Use Memento.Table.wait when it gets implemented
    Memento.Table.create(EmoteStore.Emote, disc_copies: nodes)
    Memento.Table.create(EmoteStore.Work, disc_copies: nodes)
  end
end
