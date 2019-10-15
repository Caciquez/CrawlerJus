# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     CrawlerJus.Repo.insert!(%CrawlerJus.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias CrawlerJus.Repo
alias CrawlerJus.Processes
alias CrawlerJus.Processes.Court

import Ecto.Query, warn: false

if Repo.aggregate(Court, :count, :id) == 0 do
  {:ok, _court} =
    Processes.create_court(%{
      name: "Tribunal de Justiça do Alagoas",
      name_abbreviation: "TJAL",
      url: "https://www2.tjal.jus.br/cpopg/open.do"
    })
end
