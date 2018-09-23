defmodule Periodically do
  @moduledoc """
  Genserver that periodically sents an HTTP request to an endpoint
  """
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Application.ensure_all_started(:inets)
    Application.ensure_all_started(:ssl)
    # Schedule work to be performed at some point
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, _body}} =
      :httpc.request(:get, {'https://auto-host-me.herokuapp.com/', []}, [], [])

    debug("Successfully pinged https://auto-host-me.herokuapp.com")
    # Reschedule once more
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    # In 15 mins
    Process.send_after(self(), :work, 15 * 60 * 1000)
  end

  defp debug(msg) do
    IO.puts(IO.ANSI.yellow() <> msg <> IO.ANSI.reset())
  end
end
