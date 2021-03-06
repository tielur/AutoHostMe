use Mix.Config

port =
  case System.get_env("PORT") do
    port when is_binary(port) ->
      String.to_integer(port)

    # default port
    nil ->
      4000
  end

config :auto_host_me, port: port
