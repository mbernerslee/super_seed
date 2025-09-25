defmodule SuperSeed.InserterWorkersStatus do
  def determine(workers) do
    Enum.reduce_while(workers, {:finished, :ok}, fn
      {_, %{status: :pending}}, _ -> {:halt, :running}
      {_, %{status: :running}}, _ -> {:halt, :running}
      {_, %{status: :halted}}, _ -> {:cont, {:finished, :error}}
      {_, %{status: :error}}, _ -> {:cont, {:finished, :error}}
      {_, %{status: :finished}}, acc -> {:cont, acc}
    end)
  end
end
