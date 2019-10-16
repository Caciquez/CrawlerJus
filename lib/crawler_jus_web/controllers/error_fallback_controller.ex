defmodule CrawlerJusWeb.ErrorFallbackController do
  use Phoenix.Controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{message: changeset})
    |> halt()
  end

  def call(conn, {:error, message}) when is_binary(message) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{error: message})
  end

  def call(conn, {:error, :refused}) do
    conn
    |> put_status(:not_acceptable)
    |> json(%{message: "Ocorreu um erro durante a busca de seu processo! Tente novamente"})
    |> halt()
  end

  def call(conn, {:error, :timeout}) do
    conn
    |> put_status(:request_timeout)
    |> json(%{message: "Tempo de requisição esgotado"})
    |> halt()
  end

  def call(conn, {:error, :no_location_header}) do
    conn
    |> send_resp(404, "Codigo de processo não existente")
  end

  def call(conn, {:error, _error}) do
    put_status(conn, :not_acceptable)
  end

  def call(conn, _error) do
    conn
    |> put_status(:unauthorized)
    |> json(%{message: "Ocorreu um erro durante a busca de seu processo! Tente novamente"})
    |> halt()
  end
end
