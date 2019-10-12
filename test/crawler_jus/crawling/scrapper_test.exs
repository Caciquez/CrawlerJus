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
      assert Scrapper.scrap_judge(html_body) == "Antonio Emanuel Dória Ferreira"
      assert Scrapper.scrap_action_value(html_body) == "R$         510,00"

      # assert Scrapper.scrap_process_parts(html_body) == %{
      #          " Defensor P92032" => "Defensor",
      #          " Procurador77589" => "Município de Maceió",
      #          " Réu35688" => "Sabrina da Silva Cerqueira Dattoli ",
      #          "Autor95575" => "' de Alagoas"
      #        }

      assert Scrapper.scrap_process_movimentations(html_body) == [
               %{
                 "data" => "15/09/2017",
                 "moviment" => "Baixa Definitiva",
                 "moviment_url" => nil
               },
               %{
                 "data" => "05/07/2016",
                 "moviment" =>
                   "Determinada Requisição de InformaçõesProcesso n° 0067154-55.2010.8.02.0001 Ação: Ação Civil Pública Autor: ''Defensoria Publica do Estado de AlagoasRéu: Município de Maceió DESPACHOAo cartório para verificar prazo para interposição de recurso.Havendo trânsito em julgado, arquivem-se os autos com baixa na distribuição.Maceió, 05 de julho de 2016.Antonio Emanuel Dória Ferreira Juiz de Direito",
                 "moviment_url" =>
                   "/cpopg/abrirDocumentoVinculadoMovimentacao.do?processo.codigo=01000C2TB0000&cdDocumento=17382836&nmRecursoAcessado=Determinada+Requisi%C3%A7%C3%A3o+de+Informa%C3%A7%C3%B5es"
               },
               %{
                 "data" => "11/07/2014",
                 "moviment" => "Conclusos",
                 "moviment_url" => nil
               },
               %{
                 "data" => "11/07/2014",
                 "moviment" => "Juntada de Documento",
                 "moviment_url" => nil
               },
               %{
                 "data" => "11/07/2014",
                 "moviment" => "Juntada de Documento",
                 "moviment_url" => nil
               }
             ]
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
