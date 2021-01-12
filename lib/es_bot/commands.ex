defmodule ESBot.Commands do
  @commands [ESBot.Commands.Emote]

  def commands(), do: @commands

  def get_command_specs(), do: Enum.map(@commands, &(&1.get_command_spec()))

  def run_command(command_name, interaction) do
    command_module = "Elixir.ESBot.Commands." <> String.capitalize(command_name) |> String.to_atom()
    command_module.run(interaction)
  end
end
