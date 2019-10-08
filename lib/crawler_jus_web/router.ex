defmodule CrawlerJusWeb.Router do
  use CrawlerJusWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CrawlerJusWeb do
    pipe_through :browser

    get "/", SearchController, :index
    get("/search-process", SearchController, :show)
  end

  # Other scopes may use custom stacks.
  # scope "/api", CrawlerJusWeb do
  #   pipe_through :api
  # end
end
