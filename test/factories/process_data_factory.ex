defmodule CrawlerJus.ProcessDataFactory do
  defmacro __using__(_opts) do
    alias Faker.Code

    quote do
      def process_data_factory do
        %CrawlerJus.Processes.ProcessData{
          process_code: Code.issn(),
          court: build(:court),
          data: %{
            "action_value" => "R$ 510,00",
            "area" => "Cível",
            "class" => "Ação Civil Pública",
            "data_distribition" => "29/09/2010 às 15:57 - Sorteio",
            "judge" => "Antonio Emanuel Dória Ferreira",
            "movimentations_list" => [
              %{
                "data" => "15/09/2017",
                "moviment" => "Baixa Definitiva",
                "moviment_url" => "/url/com/dados/do/processo"
              },
              %{
                "data" => "05/07/2016",
                "moviment" => "Baixa definitiva",
                "moviment_url" => "/url/com/dados/do/processo"
              }
            ],
            "parts" => %{
              " Defensor" => "Defensor",
              " Procurador" => "Município de Maceió"
            },
            "subject_matter" => "Tratamento Médico-Hospitalar e/ou Fornecimento de Medicamentos"
          }
        }
      end
    end
  end
end
