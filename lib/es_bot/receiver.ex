defmodule ESBot.Receiver do
  use Nostrum.Consumer

  require Logger

  @test_guild_id 781256007430307870

  @spec start_link :: Supervisor.on_start()
  def start_link do
    Consumer.start_link(__MODULE__, name: ESBot.Receiver)
  end

  def handle_event({:READY, _data, _ws_state}) do
    Enum.each(ESBot.Commands.get_command_specs(), fn command_spec ->
      Logger.info("Registering command in test guild")
      {:ok, _} = Nostrum.Api.create_guild_application_command(@test_guild_id, Map.put(command_spec, :name, command_spec.name <> "-test"))

      if Application.get_env(:es_bot, :register_globally) do
        Logger.info("Registering command globally")
        {:ok, _} = Nostrum.Api.create_global_application_command(command_spec)
      end
    end)
  end

  def handle_event({:INTERACTION_CREATE, %{data: %{name: command_name}} = interaction, _ws_state}) do
    command_name
    |> String.replace_trailing("-test", "")
    |> ESBot.Commands.run_command(interaction)
  end

  def handle_event(_event) do
    :noop
  end
end
