defmodule SuperSeed.Init do
  @moduledoc """
  Reads config to get the inserter modules, OTP application and Repo under the given name.

  logs an error and halts the system if anything goes wrong
  """
  require Logger
  alias SuperSeed.Init.InserterModulesValidator
  alias SuperSeed.Init.ModuleNamespace
  alias SuperSeed.SideEffectsWrapper

  def run do
    fetch_default_config() |> get_inserters_and_repo()
  end

  def run(inserter_group) do
    inserter_group
    |> fetch_config()
    |> get_inserters_and_repo()
  end

  defp get_inserters_and_repo(config) do
    with {:ok, %{namespace: namespace, repo: repo, app: app}} <- config,
         {:ok, modules} <- get_app_modules(app, namespace),
         :ok <- ensure_app_started(app),
         inserters <- ModuleNamespace.filter(modules, namespace),
         :ok <- InserterModulesValidator.validate(inserters) do
      {:ok, %{inserters: inserters, repo: repo}}
    end
  end

  defp get_app_modules(app, _namespace) do
    case SideEffectsWrapper.application_get_key(app, :modules) do
      {:ok, modules} -> {:ok, modules}
      :undefined -> {:error, {:init, :inserter_modules_not_found}}
    end
  end

  defp fetch_config(inserter_group) do
    :super_seed
    |> SideEffectsWrapper.application_get_all_env()
    |> parse_config()
    |> fetch_inserter_group(inserter_group)
  end

  defp fetch_default_config do
    :super_seed
    |> SideEffectsWrapper.application_get_all_env()
    |> parse_config()
    |> fetch_default_inserter_group()
  end

  defp fetch_default_inserter_group({:ok, config}) do
    default_inserter_group = config[:default_inserter_group]

    case config[:inserter_groups][default_inserter_group] do
      %{} ->
        fetch_inserter_group({:ok, config}, default_inserter_group)

      _ ->
        {:error, {:init, :default_inserter_group_not_found}}
    end
  end

  defp fetch_default_inserter_group(error) do
    error
  end

  defp fetch_inserter_group({:ok, config}, inserter_group) do
    case config do
      %{inserter_groups: %{^inserter_group => %{namespace: namespace, repo: repo, app: app}}} ->
        {:ok, %{namespace: to_string(namespace), repo: repo, app: app}}

      _ ->
        {:error, {:init, :inserter_group_not_found}}
    end
  end

  defp fetch_inserter_group(error, _inserter_group) do
    error
  end

  defp parse_config(config) do
    case config do
      list when is_list(list) ->
        {:ok, Map.new(list)}

      nil ->
        {:error, {:init, :missing_config}}

      _ ->
        {:error, {:init, :config_in_wrong_format}}
    end
  end

  defp ensure_app_started(app) do
    case SideEffectsWrapper.application_ensure_all_started(app) do
      {:ok, _} -> :ok
      {:error, _} -> {:error, {:init, :app_not_started, app}}
    end
  end
end
