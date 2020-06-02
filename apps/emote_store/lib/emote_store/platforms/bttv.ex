defmodule EmoteStore.Platforms.BTTV do
  def get_page(page) do
    with {:ok, response} <- HTTPoison.get("https://api.betterttv.net/3/emotes/shared/top?offset=#{50 * page - 49}&limit=50"),
         {:ok, body} <- Jason.decode(Map.get(response, :body)) do
      {:ok,
       body
       |> Enum.filter(fn %{"emote" => %{"imageType" => type}} ->
         type == "gif"
       end)
       |> Enum.map(fn %{"emote" => %{"id" => id, "code" => name}} ->
         %{name: name, url: "https://cdn.betterttv.net/emote/#{id}/3x"}
       end)}
    end
  end
end
