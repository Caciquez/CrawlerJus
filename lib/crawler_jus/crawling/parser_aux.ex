defmodule CrawlerJus.ParserAux do
  def extract_parts_names(html_body) do
    case Floki.find(html_body, "#tableTodasPartes") do
      [] ->
        extract_existing_parts_names(html_body)

      _ ->
        extract_all_parts_names(html_body)
    end
  end

  defp extract_all_parts_names(html_body) do
    html_body
    |> Floki.find("#tableTodasPartes")
    |> extract_process_part_value()
  end

  defp extract_existing_parts_names(html_body) do
    table1 =
      html_body
      |> Floki.find("#tablePartesPrincipais .fundoClaro:nth-child(1) > td:nth-child(2)")
      |> extract_process_part_value

    table2 =
      html_body
      |> Floki.find("#tablePartesPrincipais .fundoClaro:nth-child(2) > td:nth-child(2)")
      |> extract_process_part_value

    table1 ++ table2
  end

  def extract_roles_names(html_body) do
    case Floki.find(html_body, "#tableTodasPartes .fundoClaro span.mensagemExibindo") do
      [] ->
        extract_existing_roles_values(html_body)

      _ ->
        extract_all_roles_values(html_body)
    end
  end

  defp extract_existing_roles_values(html_body) do
    html_body
    |> Floki.find("#tablePartesPrincipais .fundoClaro span.mensagemExibindo")
    |> Floki.text()
    |> String.split(":")
    |> List.delete(" ")
  end

  defp extract_all_roles_values(html_body) do
    html_body
    |> Floki.find("#tableTodasPartes .fundoClaro span.mensagemExibindo")
    |> Floki.text()
    |> String.split(":")
    |> List.delete(" ")
  end

  defp extract_process_part_value(html_word) do
    html_word
    |> Floki.text()
    |> String.replace(~r/(\w*:\w+|\w+:\w*)/, "")
    |> String.replace("Defensor", "")
    |> String.replace(~r/ {2,}/, "")
    |> String.replace("\t", "")
    |> String.trim()
    |> String.split("\n")
    |> Enum.uniq()
    |> List.delete("")
    |> List.delete(" ")
  end

  def extract_moviment_date(html_body) do
    html_body
    |> Floki.find("tr > td:first-child")
    |> Floki.text()
    |> word_cleaner_aux()
  end

  def extract_moviment_content(html_body) do
    html_body
    |> Floki.find("tr > td:nth-child(3)")
    |> Floki.text()
    |> word_cleaner_aux()
  end

  def extract_moviment_url(html_body) do
    html_body
    |> Floki.find("tr > td > .linkMovVincProc")
    |> Floki.attribute("href")
    |> Enum.uniq()
    |> check_movimentation_url()
  end

  defp check_movimentation_url([]), do: nil

  defp check_movimentation_url([url]) do
    case String.match?(url, ~r/(\/[0-9].*\?|$)/) && url != "#liberarAutoPorSenha" do
      true -> url
      false -> nil
    end
  end

  def word_cleaner_aux(word) do
    word |> String.trim() |> String.replace("\t", "") |> String.replace("\n", "")
  end

  def aux_process_data_table_size(html_body) do
    html_body |> Floki.find("div:nth-child(7) .secaoFormBody > tr ") |> length
  end
end
