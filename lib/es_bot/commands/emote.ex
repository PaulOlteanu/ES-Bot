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
        type: 3,
        name: "emote_source",
        description: "Where to search for the emote. If unsure, 7tv is the safe guess as they tend to have everything",
        required: false,
        choices: [
          %{
            name: "7TV",
            value: "7tv"
          },
          %{
            name: "BetterTTV (BTTV)",
            value: "bttv"
          },
          %{
            name: "FrankerFaceZ (FFZ)",
            value: "ffv"
          }
        ]
      },
      %{
        type: 4,
        name: "index",
        description: "If the 1st result wasn't what you wanted, try the 2nd or 3rd",
        required: false
      }
    ]
  }

  def get_command_spec(), do: @command_spec

  def run(%{data: %{options: options}, channel_id: channel_id} = interaction) do
    provider =
      options
      |> Helpers.get_interaction_option_value("emote_source", "7tv")
      |> case do
        "7tv" -> :seven_tv
        "bttv" -> :bttv
        "ffz" -> :ffz
        _ -> nil
      end

    emote_name = Helpers.get_interaction_option_value(options, "emote_name")

    index = Helpers.get_interaction_option_value(options, "index", 1)

    Api.create_interaction_response(interaction, %{type: 4, data: %{
      content: "Sending emote...",
    }})

    # Before this point index is 1 based, after this point it is 0 based
    index = index - 1

    try do
      # This probably shouldn't be inside a try but I'm too lazy to fix all the error handling
      emote_name
      |> get_emote(provider, index)
      |> send_emote(channel_id)
    after
      # Ensure we delete our temporary message
      Api.get_channel_messages(channel_id, 5)
      |> elem(1)
      |> Enum.filter(fn %{author: %{username: user}, content: text} -> user == "ES Bot" && text == "Sending emote..." end)
      |> List.last()
      |> Api.delete_message()
    end
  end

  defp get_emote(_, nil, _), do: nil

  defp get_emote(emote_name, provider, index) do
    provider = ESBot.Emotes.Providers.get_provider(provider)
    emote =
      case provider.search(emote_name) do
        {:ok, emotes} -> find_emote(emotes, emote_name, index)
        _ -> nil
      end

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

  defp find_emote(emotes, emote_name, index) do
    if contains_caps?(emote_name) do
      emotes
      |> Enum.filter(fn %{name: name} -> name == emote_name end)
      |> Enum.at(index)
    else
      Enum.at(emotes, index)
    end
  end

  defp contains_caps?(string), do: String.downcase(string) != string

  defp send_emote(nil, _), do: :ok

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

      e ->
        Logger.warn("Unknown response from db: #{inspect(e)}")
        :error
    end
  end
end
