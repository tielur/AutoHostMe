defmodule AutoHostMe.State do
  @moduledoc """
  State struct used in `AutoHostMe.ConnectionHandler`
  """
  defstruct host: "irc.twitch.tv",
            port: 6667,
            pass: System.get_env("TWITCH_OAUTH_TOKEN"),
            nick: System.get_env("TWITCH_USER"),
            user: System.get_env("TWITCH_USER"),
            name: System.get_env("TWITCH_USER"),
            client: nil
end
