defmodule SuperSeed do
  require Logger
  alias SuperSeed.{Init, InserterModulesValidator, Server}

  def run(name) do
    with {:ok, %{repo: repo, inserters: inserters}} <- Init.run(name),
         :ok <- InserterModulesValidator.validate(inserters) do
      Server.run(repo, inserters)

      receive do
        :server_done -> :ok
      end
    else
      # TODO test & action these errors properly
      {:error, {:init, :inserter_modules_not_found}} ->
        nil

      {:error, {:init, :config_in_wrong_format}} ->
        nil

      {:error, {:init, :missing_config}} ->
        nil

      {:error, {:inserter_module_validation, _module, :malformed}} ->
        nil
    end
  end
end
