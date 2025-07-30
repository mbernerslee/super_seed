defmodule SuperSeedTest do
  @moduledoc """
  Async false because we're changing application env stuff, which would effect other tests if run in parallel.
  Testing the real super_seed config as defined in config/test.exs, so this is a high level e2e-ish test.
  """

  use SuperSeed.Support.DataCase, async: false
  # use Mimic
  alias SuperSeed.Repo
  alias SuperSeed.SideEffectsWrapper
  alias SuperSeed.Support.Inserters.Farms
  alias SuperSeed.Support.Schemas.Farm

  setup_all do
    Application.put_env(
      :super_seed,
      :side_effects_wrapper_module,
      SuperSeed.SideEffectsWrapper.Real
    )

    on_exit(fn ->
      Application.put_env(
        :super_seed,
        :side_effects_wrapper_module,
        SuperSeed.SideEffectsWrapper.Fake
      )
    end)
  end

  describe "run/1" do
    test "given an inserter atom, run the inserter" do
      # Mimic.copy(SideEffectsWrapper)

      SuperSeed.run(:farms)

      name = Farms.name()

      # Mimic.expect(SideEffectsWrapper, :application_get_env, 1, fn :super_seed, :inserters, %{} ->
      #  %{
      #    farms: %{namespace: SuperSeed.Support.Inserters, repo: SuperSeed.Repo, app: :super_seed}
      #  }
      # end)

      # Mimic.expect(SideEffectsWrapper, :application_get_key, 1, fn :super_seed, :modules ->
      #  []
      # end)

      assert [%Farm{name: ^name}] = Repo.all(Farm)
    end

    # TODO deal with config missing / malformed
  end
end
