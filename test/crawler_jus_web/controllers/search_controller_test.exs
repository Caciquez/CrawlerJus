defmodule CrawlerJusWeb.SearchControllerTest do
  use CrawlerJusWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Crawler"
  end
end
