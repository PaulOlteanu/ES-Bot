defmodule Bot.Commands.Default do
  alias Nostrum.Api

  def run(msg, [command | _args]) do
    case String.downcase(command) do
      "!octavian" -> Api.create_message(msg.channel_id, "is a retard")
      _ -> Api.create_message(msg.channel_id, "Unknown command")
    end
  end
end
