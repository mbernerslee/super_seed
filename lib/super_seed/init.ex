defmodule SuperSeed.Init do
  @moduledoc """
  Reads config to get the inserter modules and Repo under the given name.

  logs an error and halts the system if anything goes wrong
  """
  require Logger
  alias SuperSeed.SideEffectsWrapper

  @defaut_key :arbitrary_hopefully_unique_key_name

  def run do
    @default_key
    |> fetch_config()
    |> do_run_with_config()
    |> IO.inspect()
  end

  def run(inserter_group) do
    inserter_group |> fetch_config() |> do_run_with_config()
  end

  defp do_run_with_config(config) do
    with {:ok, %{namespace: namespace, repo: repo, app: app}} <- config,
         {:ok, modules} <- get_app_modules(app, namespace) do
      inserters = filter_inserter_modules_by_namespace(modules, namespace)
      {:ok, %{inserters: inserters, repo: repo}}
    end
  end

  defp filter_inserter_modules_by_namespace(modules, namespace) do
    Enum.filter(modules, fn module ->
      String.starts_with?(to_string(module), "#{namespace}.")
    end)
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

    # |> case do
    #  list when is_list(list) ->
    #    {:ok, Map.new(list)}

    #  nil ->
    #    {:error, {:init, :missing_config}}

    #  _ ->
    #    IO.inspect("HERE!")
    #    {:error, {:init, :config_in_wrong_format}}
    # end
    # |> case do
    #  {:ok, %{inserters: %{^inserter_group => %{namespace: namespace, repo: repo, app: app}}}} ->
    #    {:ok, %{namespace: to_string(namespace), repo: repo, app: app}}

    #  {:ok, _} ->
    #    # TODO test this
    #    {:error, {:init, :inserter_group_not_found}}

    #  error ->
    #    error
    # end
  end

  defp fetch_inserter_group({:ok, config}, @default_key) do
    default_inserter_group = config[:default_inserter_group]

    case config[:inserters][default_inserter_group] do
      %{} ->
        fetch_inserter_group({:ok, config}, default_inserter_group)

      _ ->
        {:error, {:init, :default_inserter_group_not_found}}
    end
  end

  defp fetch_inserter_group({:ok, config}, inserter_group) do
    case config do
      %{inserters: %{^inserter_group => %{namespace: namespace, repo: repo, app: app}}} ->
        {:ok, %{namespace: to_string(namespace), repo: repo, app: app}}

      _ ->
        # TODO test this
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
end
