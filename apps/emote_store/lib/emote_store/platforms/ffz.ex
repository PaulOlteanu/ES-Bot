defmodule EmoteStore.Platforms.FFZ do
  def get_page(page) do
    with {:ok, response} <- HTTPoison.get("https://api.frankerfacez.com/v1/emoticons?per_page=50&page=#{page}&sort=count-desc", timeout: 20_000, recv_timeout: 20_000),
         {:ok, body} <- Jason.decode(Map.get(response, :body)),
         emotes = Map.get(body, "emoticons") do
      {:ok,
       emotes
       |> Enum.map(fn %{"name" => name, "urls" => urls} ->
         size =
           Map.keys(urls)
           |> Enum.max_by(&elem(Integer.parse(&1), 0))

         %{name: name, url: "https:" <> urls[size]}
       end)}
    end
  end
end
