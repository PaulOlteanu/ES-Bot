defmodule ESBot.Helpers do
  def get_interaction_option_value(options, option, default \\ nil) do
    Enum.find(options, &(&1.name == option))
    |> case do
      nil -> default
      option -> Map.get(option, :value)
    end
  end
end
