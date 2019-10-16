defmodule CrawlerJus.ProcessDataFactory do
  defmacro __using__(_opts) do
    quote do
      def process_data_factory do
        %CrawlerJus.Processes.ProcessData{
          process_code: "0067154-55.2010.8.02.0001",
          court: build(:court),
          data: %{
            "action_value" => "R$ 510,00",
            "area" => "Cível",
            "class" => "Ação Civil Pública",
            "data_distribition" => "29/09/2010 às 15:57 - Sorteio",
            "judge" => "Antonio Emanuel Dória Ferreira",
            "movimentations_list" => [
              %{
                "date" => "15/09/2017",
                "content" => "Baixa Definitiva",
                "moviment_url" => "/url/com/dados/do/processo"
              },
              %{
                "date" => "05/07/2016",
                "content" => "Baixa definitiva",
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
