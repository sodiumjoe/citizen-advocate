defmodule Action.PageController do
  use Action.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
