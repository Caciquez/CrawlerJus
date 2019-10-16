defmodule CrawlerJus.ScrapperTest do
  use CrawlerJusWeb.ConnCase
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias CrawlerJus.{CrawlerEngine, Scrapper}

  setup do
    ExVCR.Config.cassette_library_dir("fixture/scrapper_cassets")
    :ok
  end

  test "scrapper methods" do
    use_cassette "scrap_process_sucess" do
      {:ok, html_body, _headers} = CrawlerEngine.start_crawler("0067154-55.2010.8.02.0001")
      assert Scrapper.scrap_process_class(html_body) == "Ação Civil Pública"
      assert Scrapper.scrap_process_area(html_body) == "Cível"

      assert Scrapper.scrap_process_subject_matter(html_body) ==
               "Tratamento Médico-Hospitalar e/ou Fornecimento de Medicamentos"

      assert Scrapper.scrap_date_of_distribution(html_body) == "29/09/2010 às 15:57 - Sorteio"
      assert Scrapper.scrap_judge(html_body) == "Geraldo Tenório Silveira Júnior"
      assert Scrapper.scrap_action_value(html_body) == "R$         510,00"

      assert Scrapper.scrap_process_parts(html_body) == [
               %{"Autor" => "' de Alagoas"},
               %{" Defensor P" => "Sabrina da Silva Cerqueira Dattoli"},
               %{" Réu" => "Município de Maceió"},
               %{" Procurador" => "Procurador Geral do Município"}
             ]

      [movimentations_elements | _] = Scrapper.scrap_process_movimentations(html_body)

      assert movimentations_elements ==
               %{
                 "date" => "15/09/2017",
                 "content" => "Baixa Definitiva",
                 "moviment_url" => nil
               }
    end
  end

  test "start_scrapper/1" do
    use_cassette "scrap_process_sucess" do
      process_data = insert(:process_data)
      {:ok, html_body, _headers} = CrawlerEngine.start_crawler("0067154-55.2010.8.02.0001")
      {:ok, process_data} == Scrapper.start_scrapper(html_body)
    end
  end
end
