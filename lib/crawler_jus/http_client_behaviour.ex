defmodule CrawlerJus.HttpClientBehaviour do
  @typep url :: binary()
  @typep body :: {:form, [{atom(), any()}]}
  @typep headers ::
           [{atom(), binary()}] | [{binary(), binary()}] | %{binary() => binary()}
  @typep params :: {[params: map()]}
  @typep options :: any()

  @callback get(url, headers) :: {:ok, map()} | {:error, binary() | map()}
  @callback get(url) :: {:ok, map()} | {:error, binary() | map()}
  @callback post(url, body, headers) :: {:ok, map()} | {:error, binary() | map()}
  @callback post(url, body, headers, options) :: {:ok, map()} | {:error, binary() | map()}
  @callback post(url, body) :: {:ok, map()} | {:error, binary() | map()}
  @callback put(url, body, headers, params) :: {:ok, %{atom() => binary()}}
end
