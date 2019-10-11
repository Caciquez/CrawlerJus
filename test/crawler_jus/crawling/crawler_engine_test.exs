defmodule CrawlerJus.CrawlerEngineTest do
  use CrawlerJusWeb.ConnCase

  alias CrawlerJus.CrawlerEngine

  describe "start_crawler/2" do
    test "returns error when process code is invalid" do
      process_code = "987.00-tootledoot"

      assert {:error, invalid_process_number} = CrawlerEngine.start_crawler(process_code)
    end
  end
end
