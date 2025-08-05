defmodule SuperSeed.SideEffectsWrapper do
  @callback application_get_all_env(atom()) :: any()
  @callback application_get_key(atom(), atom()) :: {:ok, [atom()]} | :undefined

  def application_get_all_env(app), do: impl().application_get_all_env(app)
  def application_get_key(app, key), do: impl().application_get_key(app, key)

  defp impl do
    Application.fetch_env!(:super_seed, :side_effects_wrapper_module)
  end

  defmodule Real do
    @behaviour SuperSeed.SideEffectsWrapper

    def application_get_all_env(app), do: Application.get_all_env(app)
    def application_get_key(app, key), do: :application.get_key(app, key)
  end

  defmodule Fake do
    @behaviour SuperSeed.SideEffectsWrapper

    def application_get_all_env(_app) do
      %{inserters: %{farms: %{namespace: FakeNamespace, repo: :fake_repo, app: :fake_app}}}
    end

    def application_get_key(_app, _key) do
      {:ok, [FakeNamespace.FakeInserterModule]}
    end
  end
end
