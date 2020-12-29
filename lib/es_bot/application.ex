defmodule ESBot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    ESBot.Repo.init()

    children = [
      {ESBot.Receiver, %{}}
    ]

    opts = [strategy: :one_for_one, name: ESBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
