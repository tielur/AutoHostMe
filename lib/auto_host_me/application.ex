defmodule AutoHostMe.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  import Supervisor.Spec

  alias AutoHostMe.{
    ConnectionHandler,
    LoginHandler
  }

  def start(_type, _args) do
    {:ok, client} = ExIrc.start_link!()
    twitch_channels = String.split(System.get_env("TWITCH_CHANNELS"), ",")
    port = Application.fetch_env!(:auto_host_me, :port)

    children = [
      Plug.Adapters.Cowboy.child_spec(scheme: :http, plug: SimpleHttpServer, options: [port: port]),
      worker(ConnectionHandler, [client]),
      worker(LoginHandler, [client, twitch_channels]),
      worker(Periodically, [])
    ]

    opts = [strategy: :one_for_one, name: AutoHostMe.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
