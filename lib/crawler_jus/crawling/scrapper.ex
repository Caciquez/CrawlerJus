defmodule CrawlerJus.Scrapper do
  require Integer

  alias CrawlerJus.Parser

  def start_scrapper(html_body) do
    functions = __MODULE__.__info__(:functions) |> Keyword.delete(:start_scrapper)

    scrapped_data =
      Enum.reduce(functions, %{}, fn {func, _args}, acc ->
        Map.merge(acc, apply(__MODULE__, func, [html_body]))
      end)

    {:ok, scrapped_data}
  end

  def scrap_process_class(html_body) do
    %{class: html_body |> Floki.find("span:first-child > span") |> Floki.text()}
  end

  def scrap_process_area(html_body) do
    tr_size = Parser.aux_process_data_table_size(html_body)

    tr_position =
      Enum.find(1..tr_size, fn x ->
        html_body
        |> Floki.find(".secaoFormBody tr:nth-child(#{x})")
        |> List.first()
        |> elem(1)
        |> Floki.text() == "" &&
          html_body
          |> Floki.find(".secaoFormBody:last-child tr:nth-child(#{x}) tr .labelClass")
          |> Floki.text() == "Área:"
      end)

    %{
      area:
        html_body
        |> Floki.find("tr:nth-child(#{tr_position}) > td td")
        |> List.first()
        |> elem(2)
        |> Enum.at(1)
        |> Parser.word_cleaner_aux()
    }
  end

  def scrap_process_subject_matter(html_body) do
    tr_size = Parser.aux_process_data_table_size(html_body)

    tr_position =
      Enum.find(1..tr_size, fn x ->
        html_body |> Floki.find("tr:nth-child(#{x}) .labelClass") |> Floki.text() ==
          "Assunto:"
      end)

    %{
      subject_matter:
        html_body
        |> Floki.find("tr:nth-child(#{tr_position}) > td:nth-child(2) > span")
        |> Floki.text()
    }
  end

  def scrap_date_of_distribution(html_body) do
    tr_size = Parser.aux_process_data_table_size(html_body)

    tr_position =
      Enum.find(1..tr_size, fn x ->
        html_body |> Floki.find("tr:nth-child(#{x}) .labelClass") |> Floki.text() ==
          "Distribuição:"
      end)

    %{
      data_distribition:
        html_body
        |> Floki.find("tr:nth-child(#{tr_position}) > td:nth-child(2) > span")
        |> Floki.text()
    }
  end

  def scrap_judge(html_body) do
    tr_size = Parser.aux_process_data_table_size(html_body)

    tr_position =
      Enum.find(1..tr_size, fn x ->
        html_body |> Floki.find("tr:nth-child(#{x}) .labelClass") |> Floki.text() ==
          "Juiz:"
      end)

    %{
      judge:
        html_body
        |> Floki.find("tr:nth-child(#{tr_position}) > td:nth-child(2) > span")
        |> Floki.text()
    }
  end

  def scrap_action_value(html_body) do
    tr_size = Parser.aux_process_data_table_size(html_body)

    tr_position =
      Enum.find(1..tr_size, fn x ->
        html_body |> Floki.find("tr:nth-child(#{x}) .labelClass") |> Floki.text() ==
          "Valor da ação:"
      end)

    %{
      action_value:
        html_body
        |> Floki.find("tr:nth-child(#{tr_position}) > td:nth-child(2) > span")
        |> Floki.text()
    }
  end

  def scrap_process_parts(html_body) do
    list_of_roles_values =
      html_body
      |> Parser.extract_all_roles_values()
      |> Enum.map(fn x -> x <> to_string(:rand.uniform(99_999)) end)

    list_of_part_names = Parser.extract_all_parts_names(html_body)

    %{
      parts:
        list_of_roles_values
        |> Enum.zip(list_of_part_names)
        |> Enum.into(Map.new())
    }
  end

  def scrap_process_movimentations(html_body) do
    moviment_list = Floki.find(html_body, "#tabelaUltimasMovimentacoes > tr")

    moviments =
      Enum.map(moviment_list, fn element ->
        %{
          data:
            element
            |> Floki.find("tr > td:first-child")
            |> Floki.text()
            |> Parser.word_cleaner_aux(),
          moviment:
            element
            |> Floki.find("tr > td:nth-child(3)")
            |> Floki.text()
            |> Parser.word_cleaner_aux(),
          moviment_url:
            element
            |> Floki.find("tr > td > .linkMovVincProc")
            |> Floki.attribute("href")
            |> Enum.uniq()
            |> Parser.check_movimentation_url()
        }
      end)

    %{movimentations_list: moviments}
  end
end
