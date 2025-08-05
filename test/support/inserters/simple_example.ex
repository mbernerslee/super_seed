defmodule SuperSeed.Support.Inserters.SimpleExample.First do
  def table, do: "first"
  def depends_on, do: []
  def insert(_), do: :ok
end

defmodule SuperSeed.Support.Inserters.SimpleExample.Second do
  def table, do: "second"
  def depends_on, do: [{:table, "first"}]
  def insert(_), do: :ok
end
