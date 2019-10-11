defmodule CrawlerJus.Cache do
  def process_cache_expired?(process_code) do
    case Redix.command(:redix, ["TTL", process_code]) do
      {:ok, -2} -> true
      {:ok, _time_left} -> false
    end
  end

  def set_process_cache_ttl(process_code, process_data) do
    encoded_data = Jason.encode!(process_data)

    commands = [
      ["SET", process_code, encoded_data],
      ["PEXPIRE", process_code, expiring_time()]
    ]

    case Redix.pipeline(:redix, commands) do
      {:ok, ["OK", 1]} ->
        {:ok, process_code}

      {:ok, ["OK", %Redix.Error{message: msg}]} ->
        {:ok, ["OK", msg]}

      {:ok, [%Redix.Error{message: msg}, result]} ->
        {:ok, [msg, result]}

      {:error, error} ->
        {:error, error.reason}
    end
  end

  def get_process_cache_data(process_code) do
    case Redix.command(:redix, ["GET", process_code]) do
      {:ok, nil} ->
        {:ok, nil}

      {:ok, data} ->
        content = Jason.decode!(data, %{keys: :atoms})

        {:ok, content}

      {:error, error} ->
        {:error, error}
    end
  end

  defp expiring_time do
    86_400_000
    # case Application.get_env(:crawler_jus, CrawlerJusWeb.Endpoint)[:app_env] do
    #   "test" -> 3000
    #   _ -> 86_400_000
    # end
  end
end
