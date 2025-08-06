defmodule SuperSeed.Support.Inserters.ValidationExamples.CausesError do
  def table(), do: "nonexistent_table"

  def depends_on(), do: []

  def insert(_results) do
    # This will cause a database error because the table doesn't exist
    SuperSeed.Repo.query!("INSERT INTO nonexistent_table (id) VALUES (1)")
  end
end
