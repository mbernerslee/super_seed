defmodule ExampleProject.Repo do

  def transaction(fun) do
    fun.()
  end
end

