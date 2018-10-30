# defmodule SimpleHttpServer do
#   @moduledoc """
#   Simple HTTP Server served via Cowboy
#   """
#   use Plug.Builder
#   plug(Plug.Logger)

#   def call(conn, options) do
#     conn
#     # using super in order to still call the plug chain
#     |> super(options)
#     |> Plug.Conn.send_resp(200, "I'm running!")
#   end
# end

defmodule SimpleHttpServer do
  @moduledoc """
  Simple HTTP Server served via Cowboy
  """
  use Plug.Router

  plug Plug.Parsers, parsers: [:urlencoded, :multipart]
  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "success")
  end

  get "/twitch_notifications" do
    IO.inspect(conn.query_params, label: "query_params")
    IO.inspect(conn.body_params, label: "body_params")
    challenge = conn.query_params["hub.challenge"]
    send_resp(conn, 200, challenge)
  end

  match _ do
    send_resp(conn, 404, "oops")
  end

  def subscribe_to_switch_websocket do
    url = "https://api.twitch.tv/helix/webhooks/hub"
    body = %{
      "hub.callback" => System.get_env("TWITCH_WEBHOOK_CALLBACK_URL"),
      "hub.mode" => "subscribe",
      "hub.topic" => "https://api.twitch.tv/helix/streams?user_id=41579707",
      "hub.lease_seconds" => 2400, #2400 (40mins)
      "hub.secret" => "test123"
    } |> Jason.encode!
    headers = %{
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{System.get_env("TWITCH_OAUTH_TOKEN")}"
    }
    response = HTTPoison.post(url, body, headers)
  end
end