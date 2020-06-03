defmodule Bot.Commands.Emote do
  alias Nostrum.Api

  require Logger

  def run(msg, []), do: Api.create_message(msg.channel_id, "Usage: \"!e emote\"")

  def run(msg, [command, emote]) do
    run(msg, [command, emote, 1])
  end

  def run(msg, [_command, emote, 1]) do
    EmoteStore.Emote.find_default_emote(emote)
    |> send_emote(msg)
  end

  def run(msg, [_command, emote, n]) do
    emote
    |> EmoteStore.Emote.find_emotes()
    |> Enum.at(elem(Integer.parse("#{n}"), 0) - 1)
    |> send_emote(msg)
  end

  def send_emote(emote, msg) do
    case emote do
      %EmoteStore.Emote{name: name, s3_id: id} ->
        with {:ok, file} <- EmoteStore.S3.get_emote(id),
             ext = String.split(id, ".", parts: 2) |> Enum.at(1),
             {:ok, _} <- Api.create_message(msg.channel_id, file: %{name: name <> "." <> ext, body: file}) do
          Api.delete_message!(msg)
          :ok
        else
          err ->
            Logger.error("Error sending emote: #{err}")
            Api.create_message(msg.channel_id, "Something went wrong, I think I'm dying")
            :error
        end

      nil ->
        Api.create_message(msg.channel_id, "Couldn't find that emote :'(")
        :ok

      e ->
        Logger.warn("Unknown response from db: #{e}")
        :error
    end
  end
end
