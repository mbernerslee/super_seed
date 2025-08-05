defmodule SuperSeed do
  require Logger
  alias SuperSeed.{Init, InserterModulesValidator, Server}

  # TODO test this
  def run do
    Init.run() |> do_run()
  end

  def run(name) do
    name |> Init.run() |> do_run()
  end

  defp do_run(init_result) do
    with {:ok, %{repo: repo, inserters: inserters}} <- init_result,
         :ok <- InserterModulesValidator.validate(inserters) do
      Server.run(repo, inserters)

      receive do
        :server_done -> :ok
      end
    else
      # TODO test & action these errors properly
      {:error, {:init, :inserter_modules_not_found}} ->
        {:error, {:init, :inserter_modules_not_found}}

      {:error, {:init, :config_in_wrong_format}} ->
        {:error, {:init, :config_in_wrong_format}}

      {:error, {:init, :missing_config}} ->
        {:error, {:init, :missing_config}}

      {:error, {:init, :inserter_group_not_found}} ->
        {:error, {:init, :inserter_group_not_found}}

      {:error, {:init, :default_inserter_group_not_found}} ->
        {:error, {:init, :default_inserter_group_not_found}}

      {:error, {:inserter_module_validation, _module, :malformed}} ->
        {:error, {:inserter_module_validation, _module, :malformed}}
    end
  end
end
