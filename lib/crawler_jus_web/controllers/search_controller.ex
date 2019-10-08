defmodule CrawlerJusWeb.SearchController do
  use CrawlerJusWeb, :controller

  alias CrawlerJus.{ CrawlerEngine, Cache}

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, %{"court_id" => court_id, "process_code" => process_code}) do
    with {:ok, _html_body} <- CrawlerEngine.start_crawler(process_code) do
      require IEx
      IEx.pry()
    else
      {:error, :process_not_found} ->
        {:error, "process_not_found"}

      {:error, :invalid_process_number} ->
        {:error, "invalid_process_number"}
    end
  end
end
