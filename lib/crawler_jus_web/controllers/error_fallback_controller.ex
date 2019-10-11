defmodule CrawlerJusWeb.ErrorFallbackController do
  use Phoenix.Controller

  alias CrawlerJusWeb.ErrorView

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ErrorView)
    |> render("error.json", changeset)
  end

  def call(conn, {:error, message}) when is_binary(message) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{error: message})
  end

  def call(conn, {:error, :refused}) do
    conn
    |> put_status(:not_acceptable)
    |> put_view(ErrorView)
    |> render("error.json", %{message: "Ocorreu um erro"})
  end

  def call(conn, {:error, :timeout}) do
    conn
    |> put_status(:request_timeout)
    |> put_view(ErrorView)
    |> render("error.json", %{
      message: "Tempo de requisição esgotado"
    })
  end

  def call(conn, {:error, :process_not_found}) do
    put_status(conn, :process_not_found)
  end

  def call(conn, {:error, :invalid_process_number}) do
    put_status(conn, :invalid_process_number)
  end

  def call(conn, {:error, _error}) do
    put_status(conn, :not_acceptable)
  end
end
