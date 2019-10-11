defmodule CrawlerJus.Repo.Migrations.CreateCourts do
  use Ecto.Migration

  def change do
    create table(:courts) do
      add :name, :string, null: false
      add :url, :string, null: false
      add :name_abbreviation, :string, null: false

      timestamps()
    end
  end
end
