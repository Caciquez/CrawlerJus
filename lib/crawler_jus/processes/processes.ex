defmodule CrawlerJus.Processes do
  @moduledoc """
  The Processes context.
  """

  import Ecto.Query, warn: false
  alias CrawlerJus.Repo

  alias CrawlerJus.Processes.Court
  alias CrawlerJus.Processes.ProcessData

  @doc """
  Returns the list of courts.

  ## Examples

      iex> list_courts()
      [%Court{}, ...]

  """
  def list_courts do
    Repo.all(Court)
  end

  @doc """
  Gets a single court.

  Raises `Ecto.NoResultsError` if the Court does not exist.

  ## Examples

  iex> get_court!(123)
  %Court{}

  iex> get_court!(456)
  ** (Ecto.NoResultsError)

  """

  def get_court(""), do: nil

  def get_court(id), do: Repo.get(Court, id)

  @doc """
  Creates a court.

  ## Examples

      iex> create_court(%{field: value})
      {:ok, %Court{}}

      iex> create_court(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_court(attrs \\ %{}) do
    %Court{}
    |> Court.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a court.

  ## Examples

      iex> update_court(court, %{field: new_value})
      {:ok, %Court{}}

      iex> update_court(court, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_court(%Court{} = court, attrs) do
    court
    |> Court.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Court.

  ## Examples

      iex> delete_court(court)
      {:ok, %Court{}}

      iex> delete_court(court)
      {:error, %Ecto.Changeset{}}

  """
  def delete_court(%Court{} = court) do
    Repo.delete(court)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking court changes.

  ## Examples

      iex> change_court(court)
      %Ecto.Changeset{source: %Court{}}

  """
  def change_court(%Court{} = court) do
    Court.changeset(court, %{})
  end

  @doc """
  Returns the list of process_data.

  ## Examples

      iex> list_process_data()
      [%ProcessData{}, ...]

  """
  def list_process_data do
    Repo.all(ProcessData)
  end

  @doc """
  Gets a single process_data.

  Raises `Ecto.NoResultsError` if the Process data does not exist.

  ## Examples

      iex> get_process_data!(123)
      %ProcessData{}

      iex> get_process_data!(456)
      ** (Ecto.NoResultsError)

  """
  def get_process_data!(id), do: Repo.get!(ProcessData, id)

  def get_process_data_by_process_code(process_code),
    do: Repo.get_by(ProcessData, process_code: process_code)

  @doc """
  Creates a process_data.

  ## Examples

      iex> create_process_data(%{field: value})
      {:ok, %ProcessData{}}

      iex> create_process_data(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_process_data(attrs \\ %{}) do
    %ProcessData{}
    |> ProcessData.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a process_data.

  ## Examples

      iex> update_process_data(process_data, %{field: new_value})
      {:ok, %ProcessData{}}

      iex> update_process_data(process_data, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_process_data(%ProcessData{} = process_data, attrs) do
    process_data
    |> ProcessData.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ProcessData.

  ## Examples

      iex> delete_process_data(process_data)
      {:ok, %ProcessData{}}

      iex> delete_process_data(process_data)
      {:error, %Ecto.Changeset{}}

  """
  def delete_process_data(%ProcessData{} = process_data) do
    Repo.delete(process_data)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking process_data changes.

  ## Examples

      iex> change_process_data(process_data)
      %Ecto.Changeset{source: %ProcessData{}}

  """
  def change_process_data(%ProcessData{} = process_data) do
    ProcessData.changeset(process_data, %{})
  end

  def create_or_update_process_data(process_code, process_data_params, court_id) do
    case get_process_data_by_process_code(process_code) do
      nil ->
        {:ok, %ProcessData{} = process_data} =
          create_process_data(%{
            data: process_data_params,
            court_id: court_id,
            process_code: process_code
          })

        {:ok, preload_court_data_into_process(process_data)}

      %ProcessData{} = process_data ->
        {:ok, %ProcessData{} = process_data} =
          update_process_data(process_data, %{data: process_data_params, court_id: court_id})

        {:ok, preload_court_data_into_process(process_data)}
    end
  end

  def preload_court_data_into_process(process), do: Repo.preload(process, [:court])
  def valid_process_number(""), do: {:error, :process_invalid}

  def valid_process_number(process_number) do
    with 25 <- String.length(process_number),
         "8.02" <- String.slice(process_number, 16..-6),
         false <- String.match?(process_number, ~r/ˆ[a-zA-Z]/) do
      {:ok, :process_valid}
    else
      _ -> {:error, :process_invalid}
    end
  end
end
