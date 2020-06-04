defmodule Bot.Commands.Default do
  alias Nostrum.Api

  def run(msg, [command | _args]) do
    case String.downcase(command) do
      "!octavian" -> Api.create_message(msg.channel_id, "is a retard")
      "!drop" -> Api.create_message(msg.channel_id, ":corn: spam :corn: this :corn: crop :corn: to :corn: get :corn: a :corn: drop")
      "!key" -> Api.create_message(msg.channel_id, ":key: spam :key: this :key: key :key: to :key: get :key: a :key: tree")
      _ -> Api.create_message(msg.channel_id, "Unknown command")
    end
  end
end
