defmodule Periodically do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Application.ensure_all_started(:inets)
    Application.ensure_all_started(:ssl)
    schedule_work() # Schedule work to be performed at some point
    {:ok, state}
  end

  def handle_info(:work, state) do
    {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, _body}} = :httpc.request(:get, {'https://auto-host-me.herokuapp.com/', []}, [], [])
    debug "Successfully pinged https://auto-host-me.herokuapp.com"
    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 15 * 60 * 1000) # In 15 mins
  end

  defp debug(msg) do
    IO.puts(IO.ANSI.yellow() <> msg <> IO.ANSI.reset())
  end
end