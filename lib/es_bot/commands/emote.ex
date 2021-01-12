defmodule ESBot.Commands.Emote do
  alias Nostrum.Api
  alias ESBot.Repo
  alias ESBot.Helpers

  require Logger

  @command_spec %{
    name: "emote",
    description: "Get an emote",
    options: [
      %{
        type: 3,
        name: "emote_name",
        description: "Name of the emote",
        required: true
      },
      %{
        type: 4,
        name: "index",
        description: "Which result to use (can be left blank)",
        required: false
      }
    ]
  }

  def get_command_spec(), do: @command_spec

  def run(%{data: %{options: options}, channel_id: channel_id} = interaction) do
    emote_name = Helpers.get_interaction_option_value(options, "emote_name")
    index = Helpers.get_interaction_option_value(options, "index", 1)

    emote_name
    |> get_emote(index)
    |> send_emote(channel_id)

    Api.create_interaction_response(interaction, %{type: 2})
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

  defp send_emote(emote, channel_id) do
    case emote do
      %Repo.Emote{name: name, s3_id: id} ->
        with {:ok, file} <- ESBot.S3.get_emote(id),
             ext = String.split(id, ".", parts: 2) |> Enum.at(1),
             {:ok, _} <- Api.create_message(channel_id, file: %{name: name <> "." <> ext, body: file}) do
          :ok
        else
          err ->
            Logger.error("Error sending emote: #{inspect(err)}")
            :error
        end

      nil ->
        :ok

      e ->
        Logger.warn("Unknown response from db: #{inspect(e)}")
        :error
    end
  end
end
