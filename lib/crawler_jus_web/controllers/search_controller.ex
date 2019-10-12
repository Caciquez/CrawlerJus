defmodule CrawlerJusWeb.SearchController do
  use CrawlerJusWeb, :controller

  alias CrawlerJus.{Cache, CrawlerEngine, Scrapper}
  alias CrawlerJus.Processes

  action_fallback(CrawlerJusWeb.ErrorFallbackController)

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(%{assigns: %{cache_expired: true}} = conn, %{
        "court_id" => court_id,
        "process_code" => process_code
      }) do
    with {:ok, html_body, _headers} <- CrawlerEngine.start_crawler(process_code),
         {:ok, scrapped_data} <- Scrapper.start_scrapper(html_body),
         {:ok, _data} <-
           Processes.create_or_update_process_data(process_code, scrapped_data, court_id),
         {:ok, _process_code} <- Cache.set_process_cache_ttl(process_code, scrapped_data) do
      conn
      |> put_status(200)
      |> json(%{data: scrapped_data})
    end
  end

  def show(%{assigns: %{process_cached_data: process_data}} = conn, _params) do
    conn
    |> put_status(200)
    |> json(%{data: process_data})
  end
end
