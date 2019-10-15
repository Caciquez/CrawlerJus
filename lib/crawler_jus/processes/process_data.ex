defmodule CrawlerJus.Processes.ProcessData do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(data process_code court_id)a

  @derive {Jason.Encoder, except: [:__meta__, :__struct__]}

  schema "process_data" do
    field :data, :map, null: false
    field :process_code, :string, null: false

    belongs_to(:court, CrawlerJus.Processes.Court)

    timestamps()
  end

  @doc false
  def changeset(process_data, attrs) do
    process_data
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
