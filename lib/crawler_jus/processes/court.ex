defmodule CrawlerJus.Processes.Court do
  use Ecto.Schema
  import Ecto.Changeset

  schema "courts" do
    field :name, :string
    field :name_abbreviation, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(court, attrs) do
    court
    |> cast(attrs, [:name, :url, :name_abbreviation])
    |> validate_required([:name, :url, :name_abbreviation])
  end
end
