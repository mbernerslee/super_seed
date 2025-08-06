defmodule SuperSeed.SideEffectsWrapper do
  @callback application_get_all_env(atom()) :: any()
  @callback application_get_key(atom(), atom()) :: {:ok, [atom()]} | :undefined
  @callback application_ensure_all_started(atom()) :: {:ok, [atom()]} | {:error, any()}

  def application_get_all_env(app), do: impl().application_get_all_env(app)
  def application_get_key(app, key), do: impl().application_get_key(app, key)
  def application_ensure_all_started(app), do: impl().application_ensure_all_started(app)

  defp impl do
    Application.fetch_env!(:super_seed, :side_effects_wrapper_module)
  end

  defmodule Real do
    @behaviour SuperSeed.SideEffectsWrapper

    def application_get_all_env(app), do: Application.get_all_env(app)
    def application_get_key(app, key), do: :application.get_key(app, key)
    def application_ensure_all_started(app), do: Application.ensure_all_started(app)
  end

  defmodule Fake do
    @behaviour SuperSeed.SideEffectsWrapper

    def application_get_all_env(_app) do
      [
        {:default_inserter_group, :fake_inserter_group_name},
        {:inserter_groups, %{fake_inserter_group_name: %{namespace: FakeNamespace, repo: :fake_repo, app: :fake_app}}}
      ]
    end

    def application_get_key(_app, _key) do
      {:ok, [FakeNamespace.FakeInserterModule]}
    end

    def application_ensure_all_started(_app) do
      {:ok, []}
    end
  end
end
