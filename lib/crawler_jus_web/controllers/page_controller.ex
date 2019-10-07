defmodule CrawlerJusWeb.PageController do
  use CrawlerJusWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
