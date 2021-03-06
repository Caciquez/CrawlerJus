defmodule CrawlerJus.CrawlerEngine do
  def start_crawler(process_number) do
    process_number
    |> build_url
    |> execute_request
  end

  defp execute_request(url) do
    request_url = "https://www2.tjal.jus.br" <> url

    case HTTPoison.get(request_url, [],
           hackney: [cookie: "JSESSIONID=8C004D3E7C547EB03C6327334DE14921.cpopg1"]
         ) do
      {:ok, %HTTPoison.Response{status_code: status_code, headers: headers}}
      when status_code > 300 and status_code < 400 ->
        case get_location_header(headers) do
          [url] ->
            execute_request(url)

          _ ->
            {:error, :no_location_header}
        end

      {:ok, %HTTPoison.Response{status_code: 200, body: body, headers: headers}} ->
        {:ok, body, headers}

      {:ok, %HTTPoison.Response{status_code: status_code}} when status_code >= 400 ->
        {:error, :refused}

      {:error, %HTTPoison.Error{reason: :timeout}} ->
        {:error, :timeout}

      reason ->
        {:error, reason}
    end
  end

  defp build_url(process_number) do
    "/cpopg/search.do?conversationId&" <>
      "dadosConsulta.localPesquisa.cdLocal:=1&" <>
      "cbPesquisa=NUMPROC&" <>
      "dadosConsulta.tipoNuProcesso=UNIFICADO&" <>
      "numeroDigitoAnoUnificado=#{String.slice(process_number, 0..-11)}&" <>
      "foroNumeroUnificado=#{String.slice(process_number, -4..-1)}&" <>
      "dadosConsulta.valorConsultaNuUnificado=#{process_number}&" <>
      "uuidCaptcha:sajcaptcha_4613b036352e45e580fb5e5769717e49"
  end

  defp get_location_header(headers) do
    for {key, value} <- headers, String.downcase(key) == "location" do
      case String.contains?(value, ["show.do"]) do
        true -> value
        false -> []
      end
    end
  end
end
