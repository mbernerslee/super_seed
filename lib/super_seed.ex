defmodule SuperSeed do
  require Logger
  alias SuperSeed.SideEffectsWrapper

  def run(name) do
    with {:ok, %{namespace: namespace, repo: repo, app: app}} <- fetch_config(name),
         {:ok, modules} <- SideEffectsWrapper.application_get_key(app, :modules),
         {:ok, modules} <- filter_inserter_modules_by_namespace(modules, namespace) do
      {:ok, modules}
    end
  end

  defp filter_inserter_modules_by_namespace(modules, namespace) do
    modules
    |> Enum.filter(fn module ->
      String.starts_with?(to_string(module), "#{namespace}.")
    end)
    |> IO.inspect()
  end

  defp fetch_config(name) do
    :super_seed
    |> SideEffectsWrapper.application_get_env(:inserters, %{})
    |> Map.get(name)
    |> case do
      %{namespace: namespace, repo: repo, app: app} ->
        {:ok, %{namespace: to_string(namespace), repo: repo, app: app}}

      _ ->
        {:error, :bad_config}
    end
  end
end
