defmodule CrawlerJus.RedisCacheBehaviour do
  @callback process_cache_expired?(params :: String.t()) :: boolean()
end
