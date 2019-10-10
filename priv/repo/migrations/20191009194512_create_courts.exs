defmodule CrawlerJus.Repo.Migrations.CreateCourts do
  use Ecto.Migration

  def change do
    create table(:courts) do
      add :name, :string
      add :url, :string
      add :name_abbreviation, :string

      timestamps()
    end
  end
end
