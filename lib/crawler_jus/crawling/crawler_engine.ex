defmodule CrawlerJus.CrawlerEngine do
  def start_crawler(process_number) do
    case valid_process_number?(process_number) do
      true -> process_number |> build_url |> execute_request
      false -> {:error, :invalid_process_number}
    end
  end

  def execute_request(url) do
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

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      reason ->
        {:error, reason}
    end
  end

  def build_url(process_number) do
    "/cpopg/search.do?conversationId&" <>
      "dadosConsulta.localPesquisa.cdLocal:=1&" <>
      "cbPesquisa=NUMPROC&" <>
      "dadosConsulta.tipoNuProcesso=UNIFICADO&" <>
      "numeroDigitoAnoUnificado=#{String.slice(process_number, 0..-11)}&" <>
      "foroNumeroUnificado=#{String.slice(process_number, -4..-1)}&" <>
      "dadosConsulta.valorConsultaNuUnificado=#{process_number}&" <>
      "uuidCaptcha:sajcaptcha_4613b036352e45e580fb5e5769717e49"
  end

  def get_location_header(headers) do
    for {key, value} <- headers, String.downcase(key) == "location" do
      value
    end
  end

  def valid_process_number?(process_number) do
    with 25 <- String.length(process_number),
         "8.02" <- String.slice(process_number, 16..-6) do
      true
    else
      _ -> false
    end
  end

  # @Todo maybe beutify the string building by using list keys and looping then
  def query_parameters(process_number) do
    [
      conversationId: "",
      "dadosConsulta.localPesquisa.cdLocal": 1,
      cbPesquisa: "NUMPROC",
      "dadosConsulta.tipoNuProcesso": "UNIFICADO",
      numeroDigitoAnoUnificado: String.slice(process_number, 0..-11),
      foroNumeroUnificado: String.slice(process_number, -4..-1),
      "dadosConsulta.valorConsultaNuUnificado": process_number,
      "dadosConsulta.valorConsulta": "",
      uuidCaptcha: "sajcaptcha_4613b036352e45e580fb5e5769717e49"
    ]
  end
end
