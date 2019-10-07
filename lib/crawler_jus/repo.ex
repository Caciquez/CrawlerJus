defmodule CrawlerJus.Repo do
  use Ecto.Repo,
    otp_app: :crawler_jus,
    adapter: Ecto.Adapters.Postgres
end
