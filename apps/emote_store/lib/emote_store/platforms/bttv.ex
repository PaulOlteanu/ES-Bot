defmodule EmoteStore.Platforms.BTTV do
  def get_page(page) do
    with {:ok, response} <- HTTPoison.get("https://api.betterttv.net/3/emotes/shared/top?offset=#{50 * page - 49}&limit=50", timeout: 20_000, recv_timeout: 20_000),
         {:ok, body} <- Jason.decode(Map.get(response, :body)) do
      {:ok,
       body
       |> Enum.map(fn %{"emote" => %{"id" => id, "code" => name}} ->
         %{name: name, url: "https://cdn.betterttv.net/emote/#{id}/3x"}
       end)}
    end
  end
end
