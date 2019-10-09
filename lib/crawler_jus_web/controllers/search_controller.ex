defmodule CrawlerJusWeb.SearchController do
  use CrawlerJusWeb, :controller

  alias CrawlerJus.{CrawlerEngine, Scrapper}

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, %{"court_id" => court_id, "process_code" => process_code}) do
    with {:ok, html_body} <- CrawlerEngine.start_crawler(process_code),
         {:ok, _scrapped_data} <- Scrapper.start_scrapper(html_body) do
    else
      {:error, :process_not_found} ->
        {:error, "process_not_found"}

      {:error, :invalid_process_number} ->
        {:error, "invalid_process_number"}
    end
  end
end
