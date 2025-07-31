defmodule SuperSeed.SideEffectsWrapper do
  @callback application_get_env(atom(), any()) :: any()
  @callback application_get_key(atom(), atom()) :: {:ok, [atom()]} | :undefined

  def application_get_env(key, value), do: impl().application_get_env(key, value)
  def application_get_key(app, key), do: impl().application_get_key(app, key)

  defp impl do
    Application.fetch_env!(:super_seed, :side_effects_wrapper_module)
  end

  defmodule Real do
    @behaviour SuperSeed.SideEffectsWrapper

    def application_get_env(key, value), do: Application.get_env(key, value)
    def application_get_key(app, key), do: :application.get_key(app, key)
  end

  defmodule Fake do
    @behaviour SuperSeed.SideEffectsWrapper

    def application_get_env(_key, _value) do
      %{farms: %{namespace: FakeNamespace, repo: :fake_repo, app: :fake_app}}
    end

    def application_get_key(_app, _key) do
      {:ok, [FakeNamespace.FakeInserterModule]}
    end
  end
end
