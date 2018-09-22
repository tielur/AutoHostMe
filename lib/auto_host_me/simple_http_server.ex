defmodule SimpleHttpServer do
  def init(options) do
    IO.puts "initializing plug"
    options
  end

  def call(conn, options) do
    IO.puts "calling plug"

    conn
    |> Plug.Conn.send_resp(200, "I'm running!")
  end
end