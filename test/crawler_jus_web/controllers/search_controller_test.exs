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

      process_scrapped = %{
        "action_value" => "R$ 1000,00",
        "area" => "Penal",
        "class" => "Ação Penal Pública",
        "data_distribition" => "30/09/2019 às 15:57 - Sorteio",
        "judge" => "John The Monster",
        "movimentations_list" => [
          %{
            "data" => "15/09/2017",
            "moviment" => "Baixa Definitiva",
            "moviment_url" => "/url/com/dados/do/processo"
          }
        ],
        "parts" => %{
          " Defensor" => "Defensor",
          " Procurador" => "Município de Alagoas"
        },
        "subject_matter" => "Prisão Domiciliar"
      }

      RedisCacheMock
      |> expect(:process_cache_expired?, fn _process_code -> false end)

      conn =
        get(
          conn,
          Routes.search_path(conn, :show,
            court_id: court.id,
            process_code: process_data.process_code
          )
        )

      json_response(conn, 200) == process_scrapped
    end
  end
end
