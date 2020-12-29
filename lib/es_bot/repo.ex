defmodule ESBot.Repo do
  def init() do
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
    Memento.Table.create(ESBot.Repo.Emote, disc_copies: nodes)
    :mnesia.wait_for_tables([ESBot.Repo.Emote], 5_000)
  end
end
