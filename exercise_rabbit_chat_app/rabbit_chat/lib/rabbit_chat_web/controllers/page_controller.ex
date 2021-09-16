defmodule RabbitChatWeb.PageController do
  use RabbitChatWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
