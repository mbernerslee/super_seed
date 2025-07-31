defmodule SuperSeed.Support.Inserters.MinimumValid do
  def table, do: "farms"
  def depends_on, do: []
  def insert(_), do: :ok
end

defmodule SuperSeed.Support.Inserters.Empty do
end

defmodule SuperSeed.Support.Inserters.MissingDependsOn do
  def table, do: "farms"
  def insert(_), do: :ok
end

defmodule SuperSeed.Support.Inserters.MissingTable do
  def depends_on, do: []
  def insert(_), do: :ok
end

defmodule SuperSeed.Support.Inserters.MissingInsert do
  def table, do: "farms"
  def depends_on, do: []
end

defmodule SuperSeed.Support.Inserters.WrongArityTable do
  def table(_), do: "farms"
  def depends_on, do: []
  def insert(_), do: :ok
end

defmodule SuperSeed.Support.Inserters.WrongArityDependsOn do
  def table, do: "farms"
  def depends_on(_), do: []
  def insert(_), do: :ok
end

defmodule SuperSeed.Support.Inserters.WrongArityInsert do
  def table, do: "farms"
  def depends_on, do: []
  def insert, do: :ok
end
