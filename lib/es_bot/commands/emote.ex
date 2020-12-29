defmodule ESBot.Commands.Emote do
  alias Nostrum.Api
  alias ESBot.Repo

  require Logger

  def run(msg, []), do: Api.create_message(msg.channel_id, "Usage: \"!e emote\"")

  def run(msg, [command, emote]) do
    run(msg, [command, emote, "1"])
  end

  def run(msg, [_command, emote_name, index]) do
    index = elem(Integer.parse("#{index}"), 0) - 1

    get_emote(emote_name, index)
    |> send_emote(msg)
  end

  defp get_emote(emote_name, index) do
    emote = ESBot.Emotes.Search.search(emote_name, index)

    if is_nil(emote) do
      nil
    else
      if saved_emote = Repo.Emote.find_emote(emote) do
        saved_emote
      else
        Repo.Emote.create_emote(emote)
      end
    end
  end

  defp send_emote(emote, msg) do
    case emote do
      %Repo.Emote{name: name, s3_id: id} ->
        with {:ok, file} <- ESBot.S3.get_emote(id),
             ext = String.split(id, ".", parts: 2) |> Enum.at(1),
             {:ok, _} <- Api.create_message(msg.channel_id, file: %{name: name <> "." <> ext, body: file}) do
          Api.delete_message!(msg)
          :ok
        else
          err ->
            Logger.error("Error sending emote: #{inspect(err)}")
            Api.create_message(msg.channel_id, "Something went wrong, I think I'm dying")
            :error
        end

      nil ->
        Api.create_message(msg.channel_id, "Couldn't find that emote :'(")
        :ok

      e ->
        Logger.warn("Unknown response from db: #{inspect(e)}")
        :error
    end
  end
end
