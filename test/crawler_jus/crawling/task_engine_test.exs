defmodule CrawlerJus.TaskEngineTest do
  use ExUnit.Case

  alias CrawlerJus.TaskEngine

  test "Starts a simple task" do
    results =
      TaskEngine.new()
      |> TaskEngine.put(simple: fn -> "Testing" end)
      |> TaskEngine.start_task_engine()

    assert %{simple: "Testing"} == results
  end

  test "Starts multiple tasks" do
    results =
      TaskEngine.new()
      |> TaskEngine.put(first: fn -> 1 end, second: fn -> 2 end)
      |> TaskEngine.put(third: fn -> 3 end)
      |> TaskEngine.start_task_engine()

    assert %{first: 1, second: 2, third: 3} == results
  end

  test "Returns timetout when tasks take to long" do
    results =
      TaskEngine.new()
      |> TaskEngine.put(
        timeout: fn ->
          :timer.sleep(200)
          1
        end
      )
      |> TaskEngine.start_task_engine(100)

    assert %{timeout: nil} == results
  end
end
