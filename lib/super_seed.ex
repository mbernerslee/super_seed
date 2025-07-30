defmodule SuperSeed do
  require Logger

  def run(name) do
    %{namespace: namespace, repo: repo, app: app} =
      :super_seed
      |> Application.get_env(:inserters, %{})
      |> Map.get(name)

    {:ok, modules} = :application.get_key(app, :modules)

    namespace_string = to_string(namespace)

    inserters =
      modules
      |> Enum.filter(fn module ->
        String.starts_with?(to_string(module), "#{namespace_string}.")
      end)
  end
end
