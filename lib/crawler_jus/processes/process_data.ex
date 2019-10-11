defmodule CrawlerJus.Processes.ProcessData do
  use Ecto.Schema
  import Ecto.Changeset

  schema "process_data" do
    field :data, :map, null: false
    field :process_code, :string, null: false

    belongs_to(:court, CrawlerJus.Processes.Court)

    timestamps()
  end

  @doc false
  def changeset(process_data, attrs) do
    process_data
    |> cast(attrs, [:process_code, :data])
    |> validate_required([:process_code, :data])
  end
end
