defmodule CrawlerJus.RedisCache do
  @doc """
    behaviour of module for Mock tests.
  """
  @typep process_data :: map()
  @typep process_code :: String.t()
  @typep error_list :: String.t() | String.t()
  @typep error_option :: [error_list]

  @callback process_cache_expired?(process_code) :: boolean()
  @callback get_process_cache_data(process_code) ::
              {:ok, nil} | {:ok, map()} | {:error, String.t()}
  @callback set_process_cache_ttl(process_code, process_data) ::
              {:ok, String.t()} | {:ok, error_option} | {:error, String.t()}

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
      ["PEXPIRE", process_code, 86_400_000]
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
        decoded_data = Jason.decode!(data, %{keys: :atoms})

        court_data = decoded_data.court
        process_data = Map.delete(decoded_data, :court)

        {:ok, process_data, court_data}

      {:error, error} ->
        {:error, error}
    end
  end
end
