defmodule SuperSeed.SideEffectsWrapper do
  def application_get_env(key, value, default) do
    module().application_get_env(key, value, default)
  end

  def application_get_key(app, key) do
    module().application_get_key(app, key)
  end

  defp module do
    Application.fetch_env!(:super_seed, :side_effects_wrapper_module)
  end

  defmodule Real do
    def application_get_env(key, value, default) do
      Application.get_env(key, value, default)
    end

    def application_get_key(app, key) do
      :application.get_key(app, key)
    end
  end

  defmodule Fake do
    def application_get_env(_key, _value, _default) do
      %{farms: %{namespace: :fake_namespace, repo: :fake_repo, app: :fake_app}}
    end

    def application_get_key(_app, _key) do
      [:fake]
    end
  end
end
