defmodule SuperSeed.WhichInsertersCanRun do
  def determine(deps, statuses) do
    statuses
    |> Enum.reduce([], fn
      {inserter, :pending}, acc ->
        if deps_finished?(inserter, deps, statuses) do
          [inserter | acc]
        else
          acc
        end

      {inserter, _}, acc ->
        acc
    end)
    |> MapSet.new()
  end

  defp deps_finished?(inserter, deps, statuses) do
    deps
    |> Map.fetch!(inserter)
    |> Enum.all?(fn dep -> Map.fetch!(statuses, dep) == :finished end)
  end
end
