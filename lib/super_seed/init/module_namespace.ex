defmodule SuperSeed.Init.ModuleNamespace do
  def filter(modules, namespace) do
    Enum.filter(modules, fn module ->
      String.starts_with?(to_string(module), "#{namespace}.")
    end)
  end
end
