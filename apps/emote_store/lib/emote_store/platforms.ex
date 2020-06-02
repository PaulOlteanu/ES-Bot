defmodule EmoteStore.Platforms do
  @platforms %{
    ffz: EmoteStore.Platforms.FFZ,
    bttv: EmoteStore.Platforms.BTTV
  }

  def get_platform(platform), do: Map.get(@platforms, platform)
end
