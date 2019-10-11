defmodule CrawlerJus.Factory do
  use ExMachina.Ecto, repo: CrawlerJus.Repo

  use CrawlerJus.{
    CourtFactory,
    ProcessDataFactory
  }
end
