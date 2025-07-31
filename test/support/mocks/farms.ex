defmodule SuperSeed.Support.Mocks.Farms do
  # TODO use this module or lose it
  alias SuperSeed.SideEffectsWrapper

  def mock_application_get_env do
    Mimic.expect(SideEffectsWrapper, :application_get_env, 1, fn :super_seed, :inserters, %{} ->
      %{
        farms: %{namespace: SuperSeed.Support.Inserters, repo: SuperSeed.Repo, app: :super_seed}
      }
    end)
  end

  def mock_application_get_key do
    Mimic.expect(SideEffectsWrapper, :application_get_key, 1, fn :super_seed, :modules ->
      []
    end)
  end
end
