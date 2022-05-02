defmodule ESBot.Emotes.Providers.SevenTV do
  alias ESBot.Emotes.Emote

  @slug :seven_tv

  @api_url "https://api.7tv.app/v2/gql"

  @spec search(String.t()) :: {:ok, [Emote.t()]} | {:error, atom()}
  def search(emote_name) do
    headers = [{"Content-type", "application/json"}]
    with {:ok, query} <- generate_query(emote_name),
         {:ok, result} <- HTTPoison.post(@api_url, query, headers, []),
         body = Map.get(result, :body),
         {:ok, body} <- Jason.decode(body) do
      emotes = parse_results(body)
      {:ok, emotes}
    else
      _ -> {:error, :search_failed}
    end
  end

  defp generate_query(emote_name) do
    Jason.encode(%{
      "query" => "query($query: String!,$page: Int,$pageSize: Int,$globalState: String,$sortBy: String,$sortOrder: Int,$channel: String,$submitted_by: String,$filter: EmoteFilter){search_emotes(query: $query,limit: $pageSize,page: $page,pageSize: $pageSize,globalState: $globalState,sortBy: $sortBy,sortOrder: $sortOrder,channel: $channel,submitted_by: $submitted_by,filter: $filter){id,visibility,owner {id,display_name,role {id,name,color},banned}name,tags}}",
      "variables" => %{
        "query" => emote_name,
        "page" => 1,
        "pageSize" => 8,
        "limit" => 8,
        "globalState" => nil,
        "sortBy" => "popularity",
        "sortOrder" => 0,
        "channel" => nil,
        "submitted_by" => nil
      }
    })
  end

  # TODO: Check what sizes are availible for the emote before generating the URL
  @spec parse_results(map()) :: [Emote.t()]
  def parse_results(%{"data" => %{"search_emotes" => emotes}}) do
    Enum.map(emotes, fn emote ->
      %Emote{
        name: Map.get(emote, "name"),
        provider: @slug,
        provider_id: Map.get(emote, "id"),
        provider_url: get_url(Map.get(emote, "id"))
      }
    end)
  end

  def parse_results(_), do: []

  def get_url(id) do
    "https://cdn.7tv.app/emote/#{id}/2x"
  end
end
