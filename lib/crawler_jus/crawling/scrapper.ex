defmodule CrawlerJus.Scrapper do
  require Integer

  alias CrawlerJus.{ParserAux, TaskEngine}

  @spec start_scrapper(any) :: {:ok, map}
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
        data_distribition: fn -> apply(__MODULE__, Enum.at(functions, 1), [html_body]) end
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
    list_of_roles_values =
      html_body
      |> ParserAux.extract_all_roles_values()
      |> Enum.map(fn x -> x <> to_string(:rand.uniform(99_999)) end)

    list_of_part_names = ParserAux.extract_all_parts_names(html_body)

    list_of_roles_values
    |> Enum.zip(list_of_part_names)
    |> Enum.into(Map.new())
  end

  def scrap_process_movimentations(html_body) do
    moviment_list = Floki.find(html_body, "#tabelaUltimasMovimentacoes > tr")

    Enum.map(moviment_list, fn element ->
      %{
        "data" =>
          element
          |> Floki.find("tr > td:first-child")
          |> Floki.text()
          |> ParserAux.word_cleaner_aux(),
        "moviment" =>
          element
          |> Floki.find("tr > td:nth-child(3)")
          |> Floki.text()
          |> ParserAux.word_cleaner_aux(),
        "moviment_url" =>
          element
          |> Floki.find("tr > td > .linkMovVincProc")
          |> Floki.attribute("href")
          |> Enum.uniq()
          |> ParserAux.check_movimentation_url()
      }
    end)
  end
end
