defmodule SuperSeed.DependencyResolver do
  def resolve(inserters) do
    tables =
      Enum.reduce(inserters, %{}, fn {module, table, _depends_on}, acc ->
        Map.update(acc, table, [module], &[module | &1])
      end)

    Map.new(inserters, fn {module, _table, depends_on} ->
      dependants =
        depends_on
        |> Enum.flat_map(fn
          {:table, table} -> Map.fetch!(tables, table)
          {:inserter, module} -> [module]
        end)
        |> MapSet.new()

      {module, dependants}
    end)
  end
end
