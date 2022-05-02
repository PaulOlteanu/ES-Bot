defmodule ESBot.Emotes.Providers.FFZ do
  alias ESBot.Emotes.Emote

  @slug :ffz

  @api_url "https://api.frankerfacez.com/v1/emoticons"

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
      page: 1,
      per_page: 10,
      sensitive: "false",
      private: "on",
      q: emote_name,
      sort: "count-desc"
    }

    @api_url
    |> URI.parse()
    |> Map.put(:query, URI.encode_query(params))
    |> URI.to_string()
  end

  defp parse_results(%{"emoticons" => emotes}) do
    Enum.map(emotes, fn emote ->
      %Emote{
        name: Map.get(emote, "name"),
        provider: @slug,
        provider_id: Map.get(emote, "id"),
        provider_url: get_url(Map.get(emote, "id"))
      }
    end)
  end

  defp parse_results(_), do: []

  def get_url(id) do
    "https://cdn.frankerfacez.com/emote/#{id}/2"
  end
end
