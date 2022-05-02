defmodule ESBot.Emotes.Helpers do
  alias ESBot.Emotes.Emote

  @spec find_emote([Emote.t()], String.t(), integer()) :: Emote.t() | nil
  def find_emote(emotes, emote_name, index \\ 0) do
    if contains_caps?(emote_name) do
      # If the command contains caps, match only on exact matches
      Enum.map(emotes, fn emote ->
        if emote.name == emote_name, do: emote, else: nil
      end)
      |> Enum.reject(&is_nil/1)
      |> Enum.at(index)
    else
      Enum.at(emotes, index)
    end
  end

  defp contains_caps?(string) do
    String.downcase(string) != string
  end
end
