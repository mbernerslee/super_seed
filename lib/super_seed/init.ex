defmodule SuperSeed.Init do
  @moduledoc """
  Reads config to get the inserter modules and Repo under the given name.

  logs an error and halts the system if anything goes wrong
  """
  require Logger
  alias SuperSeed.SideEffectsWrapper

  def run(name) do
    with {:ok, %{namespace: namespace, repo: repo, app: app}} <- fetch_config(name),
         {:ok, modules} <- get_app_modules(app, namespace) do
      filtered_modules = filter_inserter_modules_by_namespace(modules, namespace)
      {:ok, %{modules: filtered_modules, repo: repo}}
    end
  end

  defp filter_inserter_modules_by_namespace(modules, namespace) do
    Enum.filter(modules, fn module ->
      String.starts_with?(to_string(module), "#{namespace}.")
    end)
  end

  defp get_app_modules(app, namespace) do
    case SideEffectsWrapper.application_get_key(app, :modules) do
      {:ok, modules} ->
        {:ok, modules}

      :undefined ->
        {:error, {:init, :inserter_modules_not_found}}
        # {:error,
        # "I failed to find inserter modules for app #{app}, namespace #{namespace}. Typo perhaps? Does this app and namespace exist?"}
    end
  end

  defp fetch_config(name) do
    :super_seed
    |> SideEffectsWrapper.application_get_env(:inserters)
    |> case do
      %{^name => %{namespace: namespace, repo: repo, app: app}} ->
        {:ok, %{namespace: to_string(namespace), repo: repo, app: app}}

      nil ->
        {:error, {:init, :missing_config}}

      # TODO delete comments & action errors properly at the higher level

      # {:error,
      # """
      # I couldn't find any config under :super_seed, :inserters
      # maybe there's a typo in what you ran?

      # I expect config such as:

      # config :super_seed,
      #   inserters: %{
      #     example_name: %{namespace: YourApp.Inserters, repo: YourApp.Repo, app: :your_otp_app}
      #   }
      # """}

      _ ->
        {:error, {:init, :config_in_wrong_format}}
        # {:error,
        # """
        # I didn't find the config format that I expected
        # maybe there's a typo in what you ran?

        # I expect config such as:

        # config :super_seed,
        #   inserters: %{
        #     example_name: %{namespace: YourApp.Inserters, repo: YourApp.Repo, app: :your_otp_app}
        #   }
        # """}
    end
  end
end
