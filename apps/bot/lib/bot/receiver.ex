defmodule Bot.Receiver do
  use Nostrum.Consumer

  @spec start_link :: Supervisor.on_start()
  def start_link do
    Consumer.start_link(__MODULE__, name: Bot.Receiver)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    if String.starts_with?(msg.content, "!") do
      [command | args] = String.split(msg.content, " ", trim: true)
      Bot.Commands.run(command, msg, args)
    end
  end

  # Default event handler, if you don't include this, your consumer WILL crash if
  # you don't have a method definition for each event type.
  def handle_event(_event) do
    :noop
  end
end
