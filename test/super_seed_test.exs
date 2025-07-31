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
    original = Application.get_env(:super_seed, :side_effects_wrapper_module)

    Application.put_env(
      :super_seed,
      :side_effects_wrapper_module,
      SuperSeed.SideEffectsWrapper.Real
    )

    on_exit(fn ->
      Application.put_env(
        :super_seed,
        :side_effects_wrapper_module,
        original
      )
    end)
  end

  describe "run/1" do
    test "given an inserter atom, run the inserter" do
      # Mimic.copy(SideEffectsWrapper)

      SuperSeed.run(:farms)

      name = Farms.name()

      assert [%Farm{name: ^name}] = Repo.all(Farm)
    end

    # TODO deal with config missing / malformed
  end
end
