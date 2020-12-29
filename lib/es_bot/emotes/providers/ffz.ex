defmodule ESBot.Emotes.Providers.FFZ do
  @slug :ffz

  def parse_result(%{"link" => link, "title" => title} = _emote_result) do
    name = extract_name(title)
    provider_id = extract_id(link)
    provider_url = get_url(provider_id)

    # TODO: Check api for resolutions

    %{
      name: name,
      provider: @slug,
      provider_id: provider_id,
      provider_url: provider_url
    }
  end

  defp extract_name(title) do
    String.split(title, " ")
    |> List.first()
  end

  defp extract_id(url) do
    URI.parse(url)
    |> Map.get(:path)
    |> String.split("/")
    |> List.last()
    |> String.split("-")
    |> List.first()
  end

  def get_url(id) do
    "https://cdn.frankerfacez.com/emote/#{id}/2"
  end
end
