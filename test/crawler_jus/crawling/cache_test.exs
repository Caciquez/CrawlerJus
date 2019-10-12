defmodule CrawlerJus.CacheTest do
  use CrawlerJus.DataCase, async: true

  alias CrawlerJus.RedisCacheMock

  import Mox

  describe "process_cache_expired?/1" do
    test "returns false when process_cache isnt expired" do
      process_code = "randompseudocode"

      RedisCacheMock
      |> expect(:process_cache_expired?, fn _process_code -> false end)

      refute RedisCacheMock.process_cache_expired?(process_code)
    end

    test "returns true when process_cache is expired" do
      process_code = "randompseudocode"

      RedisCacheMock
      |> expect(:process_cache_expired?, fn _process_code -> true end)

      assert RedisCacheMock.process_cache_expired?(process_code)
    end
  end

  describe "set_process_cache_ttl/2" do
    test "returns error message if has problems when saving on cache" do
      error_reason = :closed

      RedisCacheMock
      |> expect(:set_process_cache_ttl, fn _process_code, _process_data ->
        {:error, error_reason}
      end)

      assert {:error, :closed} =
               RedisCacheMock.set_process_cache_ttl("sumpseudocode", "somebrokendata")
    end

    test "returns process_code if sucessfully saves on cache" do
      process_data = insert(:process_data)

      RedisCacheMock
      |> expect(:set_process_cache_ttl, fn _process_code, _process_data ->
        {:ok, process_data.process_code}
      end)

      assert {:ok, process_code} =
               RedisCacheMock.set_process_cache_ttl(process_data.process_code, process_data.data)

      assert process_code == process_data.process_code
    end
  end

  describe "get_process_cache_data/1" do
    test "return process_cache_content if it exists" do
      process_data = insert(:process_data)

      RedisCacheMock
      |> expect(:get_process_cache_data, fn _process_code ->
        {:ok, process_data.data}
      end)

      assert {:ok, cache_data} = RedisCacheMock.get_process_cache_data(process_data.process_code)

      assert process_data.data["class"] == cache_data["class"]
      assert process_data.data["area"] == cache_data["area"]
      assert process_data.data["subject_matter"] == cache_data["subject_matter"]
      assert process_data.data["data_distribition"] == cache_data["data_distribition"]
      assert process_data.data["judge"] == cache_data["judge"]
      assert process_data.data["action_value"] == cache_data["action_value"]
      assert process_data.data["process_parts"] == cache_data["process_parts"]
      assert process_data.data["moviments"] == cache_data["moviments"]
    end

    test "returns nill when process_cache doesnt exists" do
      RedisCacheMock
      |> expect(:get_process_cache_data, fn _process_code -> {:ok, nil} end)

      assert {:ok, nil} == RedisCacheMock.get_process_cache_data("randomcode")
    end
  end
end
