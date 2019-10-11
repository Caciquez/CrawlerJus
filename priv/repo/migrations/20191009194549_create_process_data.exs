defmodule CrawlerJus.Repo.Migrations.CreateProcessData do
  use Ecto.Migration

  def change do
    create table(:process_data) do
      add :process_code, :string, null: false
      add :data, :map, null: false
      add :court_id, references(:courts, on_delete: :nothing)

      timestamps()
    end

    create index(:process_data, [:court_id])
    create index(:process_data, [:process_code])
  end
end
