defmodule CrawlerJus.CrawlerEngineTest do
  use CrawlerJusWeb.ConnCase
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias CrawlerJus.CrawlerEngine

  setup do
    HTTPoison.start()
    ExVCR.Config.cassette_library_dir("fixture/crawler_engine_cassets")
    :ok
  end

  describe "start_crawler/2" do
    test "returns html body when process code is valid" do
      use_cassette "crawl_process_sucess" do
        {:ok, html_body, headers} = CrawlerEngine.start_crawler("0067154-55.2010.8.02.0001")

        assert String.contains?(html_body, [
                 "Dados do Processo",
                 "Partes do Processo",
                 "Movimentações"
               ])

        assert {"Content-Type", "text/html;charset=UTF-8"} ==
                 List.keyfind(headers, "Content-Type", 0)
      end
    end
  end
end
