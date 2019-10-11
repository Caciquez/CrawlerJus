defmodule CrawlerJusWeb.Plugs.CheckCache do
  import Phoenix.Controller, only: [json: 2]

  use Plug.Builder

  alias CrawlerJus.Cache

  def init(opts), do: opts

  def call(conn, _opts) do
    %{"process_code" => process_code} = conn.params

    with false <- Cache.process_cache_expired?(process_code),
         {:ok, data} = Cache.get_process_cache_data(process_code) do
      conn
      |> assign(:process_cached_data, data)
    else
      {:error, msg} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{message: msg})
        |> halt()

      true ->
        conn
        |> assign(:cache_expired, true)
    end
  end
end
