defmodule ESBot.Emotes.Providers do
  alias ESBot.Emotes.Providers

  @providers %{
    ffz: Providers.FFZ,
    bttv: Providers.BTTV
  }

  def get_provider(provider), do: Map.get(@providers, provider)
end
