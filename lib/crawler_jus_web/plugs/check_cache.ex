defmodule CrawlerJusWeb.Plugs.CheckCache do
  import Phoenix.Controller, only: [json: 2]

  use Plug.Builder

  alias CrawlerJus.{Processes, RedisCache}
  alias CrawlerJus.Processes.Court

  def init(opts), do: opts

  def call(conn, _opts) do
    %{"process_code" => process_code, "court_id" => court_id} = conn.params

    with %Court{} = _court <- Processes.get_court(court_id),
         {:ok, :process_valid} <- Processes.valid_process_number(process_code),
         false <- RedisCache.process_cache_expired?(process_code),
         {:ok, process_data} = RedisCache.get_process_cache_data(process_code) do
      conn
      |> assign(:process_cached_data, process_data)
    else
      true ->
        conn
        |> assign(:cache_expired, true)

      {:error, :process_invalid} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{message: "Codigo de processo com formato invalido"})
        |> halt()

      nil ->
        conn
        |> put_status(:unauthorized)
        |> json(%{message: "Selecione um tribunal para realizar a busca!"})
        |> halt()

      {:error, msg} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{message: msg})
        |> halt()

      _ ->
        conn
        |> put_status(:unauthorized)
        |> json(%{message: "Ocorreu um errro durante a busca de seu processo! Tente novamente"})
        |> halt()
    end
  end
end
