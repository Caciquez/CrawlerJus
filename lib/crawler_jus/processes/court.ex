defmodule CrawlerJus.Processes.Court do
  use Ecto.Schema
  import Ecto.Changeset

  schema "courts" do
    field :name, :string, null: false
    field :name_abbreviation, :string, null: false
    field :url, :string

    has_many(:process_data, CrawlerJus.Processes.ProcessData)

    timestamps()
  end

  @doc false
  def changeset(court, attrs) do
    court
    |> cast(attrs, [:name, :url, :name_abbreviation])
    |> validate_required([:name, :url, :name_abbreviation])
  end
end
