defmodule ESBot.Emotes.Emote do
  alias ESBot.Emotes.Providers

  @enforce_keys [:name, :provider, :provider_id, :provider_url]
  defstruct [:name, :provider, :provider_id, :provider_url]

  @type t :: %__MODULE__{name: String.t(), provider: Providers.t(), provider_id: String.t(), provider_url: String.t()}
end
