defmodule SimpleHttpServer do
  use Plug.Builder
  plug Plug.Logger

  def call(conn, options) do
    conn
    |> Plug.Conn.send_resp(200, "I'm running!")
  end
end