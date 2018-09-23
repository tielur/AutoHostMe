defmodule SimpleHttpServer do
  use Plug.Builder
  plug(Plug.Logger)

  def call(conn, options) do
    conn
    # using super in order to still call the plug chain
    |> super(options)
    |> Plug.Conn.send_resp(200, "I'm running!")
  end
end
