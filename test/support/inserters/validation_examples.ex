defmodule SuperSeed.Support.Inserters.ValidationExamples.MinimumValid do
  def table, do: "farms"
  def depends_on, do: []
  def insert(_), do: :ok
end

defmodule SuperSeed.Support.Inserters.ValidationExamples.Empty do
end

defmodule SuperSeed.Support.Inserters.ValidationExamples.MissingDependsOn do
  def table, do: "farms"
  def insert(_), do: :ok
end

defmodule SuperSeed.Support.Inserters.ValidationExamples.MissingTable do
  def depends_on, do: []
  def insert(_), do: :ok
end

defmodule SuperSeed.Support.Inserters.ValidationExamples.MissingInsert do
  def table, do: "farms"
  def depends_on, do: []
end

defmodule SuperSeed.Support.Inserters.ValidationExamples.WrongArityTable do
  def table(_), do: "farms"
  def depends_on, do: []
  def insert(_), do: :ok
end

defmodule SuperSeed.Support.Inserters.ValidationExamples.WrongArityDependsOn do
  def table, do: "farms"
  def depends_on(_), do: []
  def insert(_), do: :ok
end

defmodule SuperSeed.Support.Inserters.ValidationExamples.WrongArityInsert do
  def table, do: "farms"
  def depends_on, do: []
  def insert, do: :ok
end
