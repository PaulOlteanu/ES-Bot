defmodule EmoteStore.Providers do
  @providers %{
    ffz: EmoteStore.Providers.FFZ,
    bttv: EmoteStore.Providers.BTTV
  }

  def get_provider(provider), do: Map.get(@providers, provider)
end
