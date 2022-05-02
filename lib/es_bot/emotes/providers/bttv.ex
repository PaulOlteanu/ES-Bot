defmodule ESBot.Emotes.Providers.BTTV do
  alias ESBot.Emotes.Emote

  @slug :bttv

  @api_url "https://api.betterttv.net/3/emotes/shared/search"

  @spec search(String.t()) :: {:ok, [Emote.t()]} | {:error, atom()}
  def search(emote_name) do
    with request = generate_request(emote_name),
         {:ok, result} <- HTTPoison.get(request, [], []),
         body = Map.get(result, :body),
         {:ok, body} <- Jason.decode(body) do
      emotes = parse_results(body)
      {:ok, emotes}
    else
      _ -> {:error, :search_failed}
    end
  end

  defp generate_request(emote_name) do
    params = %{
      offset: 0,
      limit: 10,
      query: emote_name
    }

    @api_url
    |> URI.parse()
    |> Map.put(:query, URI.encode_query(params))
    |> URI.to_string()
  end

  defp parse_results(emotes) do
    Enum.map(emotes, fn emote ->
      %Emote{
        name: Map.get(emote, "code"),
        provider: @slug,
        provider_id: Map.get(emote, "id"),
        provider_url: get_url(Map.get(emote, "id"))
      }
    end)
  end

  def get_url(id) do
    "https://cdn.betterttv.net/emote/#{id}/2x"
  end
end
