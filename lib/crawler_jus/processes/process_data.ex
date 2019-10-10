defmodule CrawlerJus.Processes.ProcessData do
  use Ecto.Schema
  import Ecto.Changeset

  schema "process_data" do
    field :data, :map
    field :process_code, :string
    field :court_id, :id

    timestamps()
  end

  @doc false
  def changeset(process_data, attrs) do
    process_data
    |> cast(attrs, [:process_code, :data])
    |> validate_required([:process_code, :data])
  end
end
