defmodule AutoHostMe.ConnectionHandler do
  defmodule State do
    defstruct host: "irc.twitch.tv",
              port: 6667,
              pass: System.get_env("TWITCH_OAUTH_TOKEN"),
              nick: System.get_env("TWITCH_USER"),
              user: System.get_env("TWITCH_USER"),
              name: System.get_env("TWITCH_USER"),
              client: nil
  end

  def start_link(client, state \\ %State{}) do
    GenServer.start_link(__MODULE__, [%{state | client: client}])
  end

  def init([state]) do
    ExIrc.Client.add_handler(state.client, self())
    ExIrc.Client.connect!(state.client, state.host, state.port)
    {:ok, state}
  end

  def handle_info({:connected, server, port}, state) do
    debug("Connected to #{server}:#{port}")
    ExIrc.Client.logon(state.client, state.pass, state.nick, state.user, state.name)
    {:noreply, state}
  end

  def handle_info(
        {:me, msg,
         %ExIrc.SenderInfo{
           host: "p0sitivitybot.tmi.twitch.tv",
           nick: "p0sitivitybot",
           user: "p0sitivitybot"
         }, channel},
        state
      ) do
    sub_message = "the raffle list is now reset"

    msg
    |> String.downcase()
    |> String.contains?(sub_message)
    |> case do
      true ->
        debug("MATCHES, SENDING ?HOSTME")
        ExIrc.Client.msg(state.client, :privmsg, channel, "?hostme")
      false -> :nothing_to_do
    end

    {:noreply, state}
  end

  # Catch-all for messages you don't care about
  def handle_info(msg, state) do
    debug("Received unknown messsage:")
    IO.inspect(msg)
    {:noreply, state}
  end

  defp debug(msg) do
    IO.puts(IO.ANSI.yellow() <> msg <> IO.ANSI.reset())
  end
end
