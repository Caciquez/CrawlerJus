defmodule CrawlerJus.Scrapper do
  def start_crapping(html_body) do
    functions = __MODULE__.__info__(:functions) |> Keyword.delete(:start_crapping)

    Enum.reduce(functions, %{}, fn {func, _args}, acc ->
      Map.merge(acc, apply(__MODULE__, func, [html_body]))
    end)
  end

  def scrap_process_class(html_body) do
    %{class: html_body |> Floki.find("span:nth-child(1) > span") |> Floki.text()}
  end

  def scrap_process_area(html_body) do
    %{
      area:
        html_body
        |> Floki.find("tr:nth-child(3) > td td")
        |> Floki.text()
        |> String.split(":")
        |> List.last()
        |> String.trim()
    }
  end

  def scrap_process_subject_matter(html_body) do
    %{
      subject_matter:
        html_body |> Floki.find("tr:nth-child(4) > td:nth-child(2) > span") |> Floki.text()
    }
  end

  def scrap_date_of_distribution(html_body) do
    %{
      data_distribition:
        html_body |> Floki.find("tr:nth-child(5) > td:nth-child(2) > span") |> Floki.text()
    }
  end

  def scrap_judge(html_body) do
    %{judge: html_body |> Floki.find("tr:nth-child(8) > td:nth-child(2) > span") |> Floki.text()}
  end

  def scrap_action_value(html_body) do
    %{
      action_value:
        html_body |> Floki.find("tr:nth-child(9) > td:nth-child(2) > span") |> Floki.text()
    }
  end

  def scrap_process_parts(html_body) do
    parts =
      html_body |> Floki.find("#tablePartesPrincipais") |> Floki.text() |> String.split("  ")

    parts = Enum.map(parts, fn element -> word_cleaner_aux(element) end)

    %{
      process_parts: %{
        author: Enum.at(parts, 0),
        defender: Enum.at(parts, 1),
        defendant: Enum.at(parts, 2),
        attorney: Enum.at(parts, 3)
      }
    }
  end

  def scrap_process_movimentations(html_body) do
    moviment_list = Floki.find(html_body, "#tabelaUltimasMovimentacoes > tr")

    moviments =
      Enum.map(moviment_list, fn element ->
        %{
          data: element |> Floki.find("tr > td:first-child") |> Floki.text() |> word_cleaner_aux,
          moviment:
            element |> Floki.find("tr > td:first-child") |> Floki.text() |> word_cleaner_aux,
          moviment_url:
            element
            |> Floki.find("tr > td > .linkMovVincProc")
            |> Floki.attribute("href")
            |> Enum.uniq()
        }
      end)

    %{movimentations_list: moviments}
  end

  defp word_cleaner_aux(word) do
    word
    |> String.trim()
    |> String.replace("\t", "")
    |> String.replace("\n", "")
  end
end
