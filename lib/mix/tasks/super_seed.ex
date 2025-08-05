defmodule Mix.Tasks.SuperSeed do
  @moduledoc """
  `mix super_seed`
  (to run your default inserter group)
  or
  `mix super_seed <name of inserter group>`

  Run all of your defined inserters
  """

  use Mix.Task

  def run([]) do
    SuperSeed.run()
  end

  def run([inserter_group]) do
    SuperSeed.run(inserter_group)
  end
end
