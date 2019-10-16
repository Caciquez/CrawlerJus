defmodule CrawlerJusWeb.SearchControllerTest do
  use CrawlerJusWeb.ConnCase
  import Mox

  describe "index/2" do
    test "returns search screen when no params sent", %{conn: conn} do
      conn = get(conn, Routes.search_path(conn, :index))
      assert html_response(conn, 200) =~ "Crawler"
    end
  end

  describe "show/2" do
    test "returns process_data_scrapped if process_code param is sent", %{conn: conn} do
      court = insert(:court)
      process_data = insert(:process_data)

      CrawlerJus.RedisCacheMock
      |> expect(:process_cache_expired?, fn _process_code -> false end)

      conn =
        get(
          conn,
          Routes.search_path(conn, :show,
            court_id: court.id,
            process_code: process_data.process_code
          )
        )

      assert json_response(conn, 200)["data"]["process_data"]["process_code"] ==
               process_data.process_code
    end
  end
end
