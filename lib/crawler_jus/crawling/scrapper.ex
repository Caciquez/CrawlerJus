defmodule CrawlerJus.Scrapper do
  require Integer

  alias CrawlerJus.{ParserAux, TaskEngine}

  def start_scrapper(html_body) do
    functions =
      __MODULE__.__info__(:functions) |> Keyword.delete(:start_scrapper) |> Keyword.keys()

    ## refactor to loop on functions list instead of using tons of pipes
    scrapped_data =
      TaskEngine.new()
      |> TaskEngine.put(
        action_value: fn -> apply(__MODULE__, Enum.at(functions, 0), [html_body]) end
      )
      |> TaskEngine.put(
        data_distribution: fn -> apply(__MODULE__, Enum.at(functions, 1), [html_body]) end
      )
      |> TaskEngine.put(judge: fn -> apply(__MODULE__, Enum.at(functions, 2), [html_body]) end)
      |> TaskEngine.put(area: fn -> apply(__MODULE__, Enum.at(functions, 3), [html_body]) end)
      |> TaskEngine.put(class: fn -> apply(__MODULE__, Enum.at(functions, 4), [html_body]) end)
      |> TaskEngine.put(
        moviments: fn -> apply(__MODULE__, Enum.at(functions, 5), [html_body]) end
      )
      |> TaskEngine.put(
        process_parts: fn -> apply(__MODULE__, Enum.at(functions, 6), [html_body]) end
      )
      |> TaskEngine.put(
        subject_matter: fn -> apply(__MODULE__, Enum.at(functions, 7), [html_body]) end
      )
      |> TaskEngine.start_task_engine()

    {:ok, scrapped_data}
  end

  def scrap_process_class(html_body) do
    html_body |> Floki.find("span:first-child > span") |> Floki.text()
  end

  def scrap_process_area(html_body) do
    tr_size = ParserAux.aux_process_data_table_size(html_body)

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

    html_body
    |> Floki.find("tr:nth-child(#{tr_position}) > td td")
    |> List.first()
    |> elem(2)
    |> Enum.at(1)
    |> ParserAux.word_cleaner_aux()
  end

  def scrap_process_subject_matter(html_body) do
    tr_size = ParserAux.aux_process_data_table_size(html_body)

    tr_position =
      Enum.find(1..tr_size, fn x ->
        html_body |> Floki.find("tr:nth-child(#{x}) .labelClass") |> Floki.text() ==
          "Assunto:"
      end)

    html_body
    |> Floki.find("tr:nth-child(#{tr_position}) > td:nth-child(2) > span")
    |> Floki.text()
  end

  def scrap_date_of_distribution(html_body) do
    tr_size = ParserAux.aux_process_data_table_size(html_body)

    tr_position =
      Enum.find(1..tr_size, fn x ->
        html_body |> Floki.find("tr:nth-child(#{x}) .labelClass") |> Floki.text() ==
          "Distribuição:"
      end)

    html_body
    |> Floki.find("tr:nth-child(#{tr_position}) > td:nth-child(2) > span")
    |> Floki.text()
  end

  def scrap_judge(html_body) do
    tr_size = ParserAux.aux_process_data_table_size(html_body)

    tr_position =
      Enum.find(1..tr_size, fn x ->
        html_body |> Floki.find("tr:nth-child(#{x}) .labelClass") |> Floki.text() ==
          "Juiz:"
      end)

    html_body
    |> Floki.find("tr:nth-child(#{tr_position}) > td:nth-child(2) > span")
    |> Floki.text()
  end

  def scrap_action_value(html_body) do
    tr_size = ParserAux.aux_process_data_table_size(html_body)

    tr_position =
      Enum.find(1..tr_size, fn x ->
        html_body |> Floki.find("tr:nth-child(#{x}) .labelClass") |> Floki.text() ==
          "Valor da ação:"
      end)

    html_body
    |> Floki.find("tr:nth-child(#{tr_position}) > td:nth-child(2) > span")
    |> Floki.text()
  end

  def scrap_process_parts(html_body) do
    list_of_roles_values = ParserAux.extract_roles_names(html_body)

    list_of_part_names = ParserAux.extract_parts_names(html_body)

    list_of_roles_values
    |> Enum.zip(list_of_part_names)
    |> Enum.map(fn {k, v} -> %{"#{k}" => v} end)
  end

  def scrap_process_movimentations(html_body) do
    moviment_list = Floki.find(html_body, "#tabelaTodasMovimentacoes > tr")

    Enum.map(moviment_list, fn element ->
      %{
        "date" => ParserAux.extract_moviment_date(element),
        "content" => ParserAux.extract_moviment_content(element),
        "moviment_url" => ParserAux.extract_moviment_url(element)
      }
    end)
  end
end
