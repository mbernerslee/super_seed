defmodule Mix.Tasks.SuperSeed do
  @moduledoc """
  `mix super_seed`
  (to run your default inserter group)
  or
  `mix super_seed <name of inserter group>`

  Run all of your defined inserters
  """

  use Mix.Task

  @shortdoc "inserts seed data"
  @requirements ["app.config"]

  def run([]) do
    SuperSeed.run()
  end

  # test changing strings to atoms!
  def run([inserter_group]) do
    inserter_group
    |> String.to_atom()
    |> SuperSeed.run()
  end
end
