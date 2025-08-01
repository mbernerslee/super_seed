defmodule SuperSeedTest do
  @moduledoc """
  Async false because we're changing application env stuff, which would effect other tests if run in parallel.
  Testing the real super_seed config as defined in config/test.exs, so this is a high level e2e-ish test.
  """

  use SuperSeed.Support.DataCase, async: false
  import Ecto.Query

  alias SuperSeed.Repo

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
      assert :ok == SuperSeed.run(:farms)

      # all strings in assertions below are from test inserters in test/support/inserters/farming/*

      assert Repo.all(from a in "farms", select: a.name) == ["Sunrise Valley"]

      assert Repo.all(from a in "animal_types", order_by: a.name, select: a.name) == [
               "Black Angus Cattle",
               "Duroc Pig",
               "Holstein Cattle",
               "Merino Sheep"
             ]

      assert Repo.all(
               from f in "feed_inventory",
                 order_by: f.supplier_batch_number,
                 select: f.supplier_batch_number
             ) == ["BATCH-001"]

      assert Repo.all(from a in "animals", order_by: a.name, select: a.name) == [
               "Bessie",
               "Dolly",
               "Thunder",
               "Wilbur"
             ]

      assert Repo.all(from f in "feed_types", order_by: f.name, select: f.name) == [
               "Calcium Mineral Supplement",
               "Corn Grain Mix",
               "High Protein Pellets",
               "Premium Hay"
             ]

      assert Repo.all(
               from f in "feeding_schedules", order_by: f.quantity_kg, select: f.quantity_kg
             ) == [Decimal.new("5.00")]

      assert Repo.all(from h in "health_records", order_by: h.record_type, select: h.record_type) ==
               ["checkup", "injury", "treatment", "vaccination"]
    end

    # TODO deal with config missing / malformed
  end
end
