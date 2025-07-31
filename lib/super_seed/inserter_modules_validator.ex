defmodule SuperSeed.InserterModulesValidator do
  @required_functions MapSet.new(depends_on: 0, insert: 1, table: 0)

  def validate(modules) do
    Enum.reduce_while(modules, :ok, fn module, _ ->
      case validate_module(module) do
        :ok -> {:cont, :ok}
        {:error, error} -> {:halt, {:error, error}}
      end
    end)
  end

  defp validate_module(module) do
    functions =
      :functions
      |> module.__info__()
      |> MapSet.new()

    if MapSet.subset?(@required_functions, functions) do
      :ok
    else
      {:error, {:inserter_module_validation, module, :malformed}}
    end
  end
end
