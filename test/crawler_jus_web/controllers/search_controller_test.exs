defmodule CrawlerJusWeb.SearchControllerTest do
  use CrawlerJusWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end

# id | process_number | data JSONB |  inserted_at | updated_at
