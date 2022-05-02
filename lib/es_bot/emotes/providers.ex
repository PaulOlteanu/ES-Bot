defmodule ESBot.Emotes.Providers do
  alias ESBot.Emotes.Providers

  @providers %{
    ffz: Providers.FFZ,
    bttv: Providers.BTTV,
    seven_tv: Providers.SevenTV
  }

  @type t :: :ffz | :bttv | :seven_tv

  def get_provider(provider), do: Map.get(@providers, provider)
end
