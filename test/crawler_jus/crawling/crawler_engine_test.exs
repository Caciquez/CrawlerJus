defmodule CrawlerJus.CrawlerEngineTest do
  use CrawlerJusWeb.ConnCase

  import Mox

  alias CrawlerJus.CrawlerEngine

  describe "start_crawler/2" do
    test "returns html body when process code is valid" do

      HttpClientMock
      |> expect(:get, fn
        _request_url, [headers: ["Content-Type": _, "Application-name": _, "token": _]] ->
          %HTTPotion.Response{status_code: 200, body: encoded_response}
      end)

      conn =
    end

    test "returns error when process code is invalid" do
      process_code = "987.00-tootledoot"

      assert {:error, invalid_process_number} = CrawlerEngine.start_crawler(process_code)
    end
  end
end
