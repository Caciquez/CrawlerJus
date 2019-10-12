defmodule CrawlerJus.TaskEngine do
  defstruct task_functions: %{}

  def new, do: %__MODULE__{}

  def put(%__MODULE__{} = object, key, function), do: put(object, [{key, function}])

  def put(%__MODULE__{task_functions: task_functions} = object, new_functions \\ []) do
    %{object | task_functions: Enum.into(new_functions, task_functions)}
  end

  def start_task_engine(%__MODULE__{task_functions: task_functions}, timeout \\ 5000) do
    {keys, tasks} =
      task_functions
      |> Enum.map(fn {k, f} -> {k, Task.async(f)} end)
      |> Enum.unzip()

    get_task_results = fn {task, res} ->
      case res || Task.shutdown(task, :brutal_kill) do
        {:ok, results} -> results
        _ -> nil
      end
    end

    task_results =
      tasks
      |> Task.yield_many(timeout)
      |> Enum.map(get_task_results)

    keys
    |> Enum.zip(task_results)
    |> Map.new()
  end
end
