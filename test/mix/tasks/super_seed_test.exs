defmodule Mix.Tasks.SuperSeedTest do
  # @moduledoc "Aync false because DB opertaions happening in many processes"
  use SuperSeed.Support.DataCase, async: false
  use Mimic

  alias SuperSeed.Support.Assertions
  alias SuperSeed.Support.Mocks
  alias SuperSeed.SideEffectsWrapper

  describe "run/1" do
    test "given an inserter_group name, runs it" do
      Mocks.use_real_config()
      assert :ok == Mix.Tasks.SuperSeed.run(["farms"])

      Assertions.assert_farm_inserter_group_db_inserts()
    end

    test "given a different inserter_group name, runs it" do
      Mocks.use_real_config()
      assert :ok == Mix.Tasks.SuperSeed.run(["simple_example"])
      Assertions.assert_simple_example_inserter_group_db_inserts()
    end

    test "when a default_inserter_group is defined, runs it" do
      Mocks.use_real_config()

      assert :ok == Mix.Tasks.SuperSeed.run([])
      Assertions.assert_farm_inserter_group_db_inserts()
    end

    test "when a default_inserter_group is defined" do
      Mimic.expect(SideEffectsWrapper, :application_get_all_env, 1, fn :super_seed ->
        [
          {:default_inserter_group, :first_group},
          {:inserter_groups,
           %{
             first_group: %{
               namespace: FirstExample,
               repo: FirstExample.Repo,
               app: :example_app
             },
             second_group: %{
               namespace: SecondExample,
               repo: SecondExample.Repo,
               app: :example_app
             }
           }}
        ]
      end)

      Mimic.expect(SideEffectsWrapper, :application_get_key, 1, fn :example_app, :modules ->
        {:ok, [SuperSeed.Support.Inserters.SimpleExample.First, Seed.Support.Inserters.SimpleExample.Second]}
      end)

      assert :ok == Mix.Tasks.SuperSeed.run([])
    end
  end
end
