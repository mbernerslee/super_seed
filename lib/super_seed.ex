defmodule SuperSeed do
  require Logger
  alias SuperSeed.{Init, InserterModulesValidator}

  def run(name) do
    with {:ok, %{repo: repo, modules: modules}} <- Init.run(name),
         :ok <- InserterModulesValidator.validate(modules) do
      :ok
    else
      # TODO test & action these errors properly
      {:error, {:init, :inserter_modules_not_found}} ->
        nil

      {:error, {:init, :config_in_wrong_format}} ->
        nil

      {:error, {:init, :missing_config}} ->
        nil

      {:error, {:inserter_module_validation, module, :malformed}} ->
        nil
    end
  end
end
