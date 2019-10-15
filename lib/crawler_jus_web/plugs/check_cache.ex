defmodule CrawlerJusWeb.Plugs.CheckCache do
  import Phoenix.Controller, only: [json: 2]

  use Plug.Builder

  alias CrawlerJus.{Processes, RedisCache}

  def init(opts), do: opts

  def call(conn, _opts) do
    %{"process_code" => process_code} = conn.params

    with true <- Processes.valid_process_number?(process_code),
         false <- RedisCache.process_cache_expired?(process_code),
         {:ok, process_data} = RedisCache.get_process_cache_data(process_code) do
      conn
      |> assign(:process_cached_data, process_data)
    else
      {:error, msg} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{message: msg})
        |> halt()

      true ->
        conn
        |> assign(:cache_expired, true)

      _ ->
        conn
        |> put_status(:unauthorized)
        |> json(%{message: "Codigo de processo com formato invalido"})
        |> halt()
    end
  end
end
