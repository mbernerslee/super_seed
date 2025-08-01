defmodule SuperSeed.WhichInsertersCanRun do
  def determine(deps, workers) do
    workers
    |> Enum.reduce([], fn
      {inserter, %{status: :pending}}, acc ->
        if deps_finished?(inserter, deps, workers) do
          [inserter | acc]
        else
          acc
        end

      _, acc ->
        acc
    end)
    |> MapSet.new()
  end

  defp deps_finished?(inserter, deps, workers) do
    deps
    |> Map.fetch!(inserter)
    |> Enum.all?(fn dep -> workers[dep][:status] == :finished end)
  end
end
