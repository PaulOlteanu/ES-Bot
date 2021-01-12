defmodule ESBot.Emotes.Search do
  @url_base "https://www.googleapis.com/customsearch/v1/siterestrict"

  def search(emote_name, result_index \\ 1) do

    # Start is 1 based
    opts = %{
      key: Application.get_env(:es_bot, :search_key),
      cx: "f96e8d3833deb4cee",
      q: emote_name,
      num: 10,
      start: (floor(result_index / 10) * 10)
    }
    url = @url_base <> "?" <> URI.encode_query(opts)

    with {:ok, response} <- HTTPoison.get(url, timeout: 50_000, recv_timeout: 50_000),
         {:ok, %{"items" => emotes}} <- Jason.decode(Map.get(response, :body)),
         emotes = Enum.reject(emotes, fn %{"link" => link} -> String.contains?(link, "users") or String.contains?(link, "channel") end) do

      index = rem(result_index - 1, 10)

      if (contains_caps?(emote_name)) do
        Enum.map(emotes, fn emote_result ->
          provider = get_provider(emote_result)
          emote = ESBot.Emotes.Providers.get_provider(provider).parse_result(emote_result)
          if emote.name == emote_name, do: emote, else: nil
        end)
        |> Enum.reject(&is_nil/1)
        |> Enum.at(index)
      else
        emote_result = Enum.at(emotes, index)
        provider = get_provider(emote_result)
        ESBot.Emotes.Providers.get_provider(provider).parse_result(emote_result)
      end
    else
      _ -> nil
    end
  end

  defp contains_caps?(string) do
    String.downcase(string) != string
  end

  defp get_provider(emote_result) do
    emote_result
    |> Map.get("displayLink")
    |> String.replace_prefix("https://", "")
    |> String.replace_prefix("http://", "")
    |> String.replace_prefix("www.", "")
    |> String.replace_trailing(".com", "")
    |> case do
      "frankerfacez" -> :ffz
      "betterttv" -> :bttv
    end
  end
end
