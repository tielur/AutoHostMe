defmodule AutoHostMe.State do
  @moduledoc """
  State struct used in `AutoHostMe.ConnectionHandler`
  """
  alias __MODULE__

  defstruct host: "irc.twitch.tv",
            port: 6667,
            pass: nil,
            nick: nil,
            user: nil,
            name: nil,
            client: nil

  def new do
    %State{
      host: "irc.twitch.tv",
      port: 6667,
      pass: "oauth:#{System.get_env("TWITCH_OAUTH_TOKEN")}",
      nick: System.get_env("TWITCH_USER"),
      user: System.get_env("TWITCH_USER"),
      name: System.get_env("TWITCH_USER"),
      client: nil
    }
  end
end
