defmodule CitizenAdvocate.PageController do
  use CitizenAdvocate.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
