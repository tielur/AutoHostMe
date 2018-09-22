defmodule SimpleHttpServer do
  use Plug.Builder
  plug Plug.Logger

  def call(conn, options) do
    conn
    |> super(opts) # using super in order to still call the plug chain
    |> Plug.Conn.send_resp(200, "I'm running!")
  end
end