defmodule CrawlerJus.ParserAux do
  def extract_all_parts_names(html_body) do
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

  def extract_all_roles_values(html_body) do
    html_body
    |> Floki.find("#tablePartesPrincipais .fundoClaro span.mensagemExibindo")
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
    |> String.split("\n")
    |> Enum.uniq()
    |> List.delete("")
    |> List.delete(" ")
  end

  def check_movimentation_url([]), do: nil

  def check_movimentation_url([url]) do
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
